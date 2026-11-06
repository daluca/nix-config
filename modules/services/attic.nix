{ self, ... }:

{
  flake.nixosModules.atticd =
    {
      config,
      lib,
      pkgs,
      secrets,
      ...
    }:
    {
      services.atticd = {
        enable = true;
        environmentFile = config.sops.templates."atticd.env".path;
        settings = {
          listen = "127.0.0.1:8082";
          allowed-hosts = [
            "attic.${secrets.domains.primary}"
          ];
          api-endpoint = "https://attic.${secrets.domains.primary}/";
          require-proof-of-possession = true;
          database.heartbeat = true;
          compression = {
            type = "zstd";
            level = 9;
          };
          storage = {
            type = "s3";
            region = "nbg1";
            bucket = "atticd";
            endpoint = "https://nbg1.your-objectstorage.com";
          };
        };
      };

      sops.templates."atticd.env".content = lib.generators.toKeyValue { } {
        ATTIC_SERVER_TOKEN_RS256_SECRET_BASE64 = config.sops.placeholder."atticd/token";
        AWS_ACCESS_KEY_ID = "BS5QQFTT4BLAX3GJAJ3T";
        AWS_SECRET_ACCESS_KEY = config.sops.placeholder."atticd/s3/secret-key";
      };

      sops.secrets."atticd/token" = { };

      sops.secrets."atticd/s3/secret-key" = { };

      services.nginx.virtualHosts."attic.${secrets.domains.primary}" = {
        forceSSL = true;
        useACMEHost = secrets.domains.primary;
        locations."/" = {
          proxyPass = "http://${config.services.atticd.settings.listen}";
          extraConfig = /* nginx */ ''
            client_max_body_size 1G;
          '';
        };
      };

      environment.systemPackages = with pkgs; [
        attic-server
      ];

      systemd.tmpfiles.settings."var-lib-private" = {
        "/var/lib/private".d = {
          user = "root";
          group = "root";
          mode = "0700";
        };
      };

      environment.persistence.system.directories = [
        {
          inherit (config.services.atticd) user group;
          directory = "/var/lib/private/atticd";
          mode = "0755";
        }
      ];
    };

  flake.nixosModules.attic-options =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      cfg = config.services.attic-watch-store;
    in
    with lib;
    {
      options.services.attic-watch-store = {
        enable = lib.mkEnableOption "attic-watch-store";

        package = lib.mkPackageOption pkgs "attic-client" { };

        apiTokenFile = lib.mkOption {
          type = types.pathWith {
            absolute = true;
            inStore = false;
          };
          description = "The path to a file containing Attic API token";
        };

        cache = lib.mkOption {
          type = types.submodule {
            options = {
              endpoint = lib.mkOption {
                type = types.str;
                description = "Endpoint for the Attic server";
              };
            };
          };
        };
      };

      config = lib.mkIf cfg.enable {
        systemd.services.attic-watch-store = {
          wantedBy = [ "multi-user.target" ];
          requires = [ "network-online.target" ];
          after = [ "network-online.target" ];
          environment.HOME = "/var/lib/attic-watch-store";
          serviceConfig = {
            DynamicUser = true;
            MemoryHigh = "5%";
            MemoryMax = "10%";
            LoadCredential = "api-token:${cfg.apiTokenFile}";
            StateDirectory = "attic-watch-store";
          };
          path = with pkgs; [
            attic-client
          ];
          script = /* bash */ ''
            set -euo pipefail

            ATTIC_TOKEN="$(< "''${CREDENTIALS_DIRECTORY}/api-token")"

            attic login central ${cfg.cache.endpoint} "''${ATTIC_TOKEN}"
            attic use central:production

            exec attic watch-store central:production
          '';
        };
      };
    };

  flake.nixosModules.attic = { config, secrets, ... }: {
    imports = with self.nixosModules; [
      attic-options
    ];

    services.attic-watch-store = {
      enable = true;
      apiTokenFile = config.sops.secrets."attic/api-token".path;
      cache.endpoint = "https://attic.${secrets.domains.general}";
    };

    sops.secrets."attic/api-token" = { };
  };

  flake.nixosModules.base = { secrets, ... }: {
    nix.settings = {
      substituters = [
        "https://attic.${secrets.domains.general}/production?priority=60"
      ];
      trusted-public-keys = [
        "production:VTqKInQ7wCs02xOciIN2EhCscskRr0ypiCzrMM8pp54="
      ];
    };
  };

  flake.homeModules.attic =
    {
      config,
      pkgs,
      secrets,
      ...
    }:
    {
      home.packages = with pkgs; [
        attic-client
      ];

      sops.templates."attic-config.toml" = {
        path = "${config.xdg.configHome}/attic/config.toml";
        content = /* toml */ ''
          default-server = "default"

          [servers.default]
          endpoint = "https://attic.${secrets.domains.general}/"
          token = "${config.sops.placeholder."attic/token"}"
        '';
      };

      sops.secrets."attic/token" = { };
    };
}
