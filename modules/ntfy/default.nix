let
  secrets = fromTOML (builtins.readFile ../../secrets/secrets.toml);
in {
  flake.homeManagerModules.ntfy = { config, lib, pkgs, osConfig, ... }: {
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
        default-host = "https://ntfy.${secrets.domain.general}";
        default-token = config.sops.placeholder."ntfy/token";
      };
    };

    sops.secrets."ntfy/token" = { };

    programs.zsh.plugins = [
      {
        name = "ntfy-long-command";
        src = ./zsh-plugin;
      }
    ];
  };
}
