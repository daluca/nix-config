{ config, lib, pkgs, secrets, hostname, ... }@args:
let
  osConfig = (if args ? "osConfig" then args.osConfig else { networking.hostName = hostname; });
in {
  home.packages = with pkgs; [
    ntfy-sh
  ];

  home.sessionVariables = {
    NTFY_TOPIC = osConfig.networking.hostName;
    NTFY_QUIET = builtins.toString true;
  };

  sops.templates."ntfy-client.yaml" = {
    path = "${config.xdg.configHome}/ntfy/client.yml";
    content = lib.generators.toYAML { } {
      default-host = "https://ntfy.${secrets.cloud.domain}";
      default-token = config.sops.placeholder."ntfy/token";
    };
  };

  services.ntfyd = {
    enable = true;
    server = "ntfy.${secrets.cloud.domain}";
  };
}
