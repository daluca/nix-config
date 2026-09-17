{ self, withSystem, ... }:

{
  perSystem = { lib, pkgs, ... }: {
    packages.ntfyd =
      with pkgs;
      rustPlatform.buildRustPackage rec {
        pname = "ntfyd";
        version = "dev";

        src = fetchFromGitHub {
          owner = "alemidev";
          repo = "ntfyd";
          rev = version;
          hash = "sha256-BCeCEEZNWCbnwLR4KrYhOatN1dbRsju0SAJ5ClQvzAw=";
        };

        cargoHash = "sha256-/elarKGwykm2+7MzA6fbSXWR6Dqdk2XJFkJcTejZmOU=";

        meta = with lib; {
          description = "ntfy.sh background notifications daemon";
          homepage = "https://github.com/alemidev/ntfyd";
          mainProgram = "ntfyd";
          license = licenses.mit;
        };
      };
  };

  flake.overlays.ntfyd = _final: prev:
    withSystem prev.stdenv.hostPlatform.system (
      { self', ... }: {
        inherit (self'.packages) ntfyd;
      }
    );

  flake.nixosModules.ntfy = { lib, ... }: {
    services.ntfy-sh = {
      enable = true;
      settings = {
        listen-http = "127.0.0.1:8080";
        behind-proxy = true;
        enable-login = true;
        auth-default-access = "deny-all";
      };
    };

    systemd.services.ntfy-sh.serviceConfig = {
      DynamicUser = lib.mkForce false;
      PrivateTmp = lib.mkForce false;
      UMask = "0002";
    };

    users.users.daluca.extraGroups = [ "ntfy-sh" ];

    environment.persistence.system.directories = [
      {
        directory = "/var/lib/ntfy-sh";
        mode = "0775";
      }
    ];
  };

  flake.homeManagerModules.ntfy =
    {
      config,
      lib,
      pkgs,
      secrets,
      osConfig,
      ...
    }:
    {
      home.packages = with pkgs; [
        ntfy-sh
      ];

      home.sessionVariables = {
        NTFY_TOPIC = "hosts";
        NTFY_TITLE = osConfig.networking.hostName;
        NTFY_QUIET = toString true;
        NTFY_LONG_ALLOWLIST = lib.concatStringsSep " " [
          "ansible-playbook"
        ];
      };

      sops.templates."ntfy-client.yaml" = {
        path = "${config.xdg.configHome}/ntfy/client.yml";
        content = lib.generators.toYAML { } {
          default-host = "https://ntfy.${secrets.domain}";
          default-token = config.sops.placeholder."ntfy/token";
        };
      };

      sops.secrets."ntfy/token" = { };

      programs.zsh.plugins = [
        {
          name = "ntfy-long-command";
          src = ./ntfy/zsh-plugin;
        }
      ];
    };

  flake.homeManagerModules.ntfyd-options =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      cfg = config.services.ntfyd;
    in
    {
      options.services.ntfyd = with lib; {
        enable = lib.mkEnableOption "ntfy.sh background notifications daemon";

        package = lib.mkPackageOption pkgs "ntfyd" { };

        server = lib.mkOption {
          type = types.str;
          default = "ntfy.sh";
          description = "ntfy.sh server domain";
        };

        token = lib.mkOption {
          type = types.str;
          default = "";
          description = "Auth token to access topics";
        };

        topics = lib.mkOption {
          type = types.listOf types.str;
          default = [ ];
          description = "Topics to subscribe to";
        };
      };

      config = lib.mkIf cfg.enable {
        systemd.user.services.ntfyd = {
          Unit = {
            Description = "ntfy.sh background notifications daemon";
            Documentation = "https://git.alemi.dev/ntfyd.git/";
            Wants = [ "network.target" ];
            After = [ "network.target" ];
          };

          Service = {
            ExecStart =
              "${lib.getExe cfg.package} --server ${cfg.server} "
              + lib.optionalString (cfg.token != "") "--token ${cfg.token} "
              + "${builtins.concatStringsSep " " cfg.topics}";
            Restart = "always";
          };

          Install = {
            WantedBy = [ "default.target" ];
          };
        };
      };
    };

  flake.homeManagerModules.ntfyd = { secrets, ... }: {
    imports = with self.homeManagerModules; [
      ntfyd-options
    ];

    services.ntfyd = {
      enable = true;
      server = "ntfy.${secrets.domain}";
      token = secrets.ntfy.token;
      topics = [
        "hosts"
        "gatus"
      ];
    };
  };
}
