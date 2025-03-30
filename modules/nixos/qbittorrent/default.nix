{ config, lib, pkgs, ... }:
let
  cfg = config.services.qbittorrent;
in with lib; {
  options.services.qbittorrent = {
    enable = lib.mkEnableOption "qBittorrent";

    package = lib.mkPackageOption pkgs "qbittorrent-nox" { };

    port = lib.mkOption {
      type = types.port;
      default = 8080;
      description = "WebUI port for qBittorrent";
    };

    openFirewall = lib.mkOption {
      type = types.bool;
      default = false;
      description = "Open ports in the firewall for the qBittorrent web interface.";
    };
  };

  config = lib.mkIf cfg.enable {
    systemd.services.qbittorrent = {
      description = "qBittorrent";
      wants = [ "network.target" ];
      after = [ "network.target" "nss-lookup.target" ];
      wantedBy = [ "multi-user.target" ];

      serviceConfig = {
        Type = "exec";
        ExecStart = "${cfg.package}/bin/qbittorrent-nox --webui-port=${builtins.toString cfg.port}";
      };
    };

    networking.firewall = lib.mkIf cfg.openFirewall {
      allowedTCPPorts = [ cfg.port ];
    };
  };
}
