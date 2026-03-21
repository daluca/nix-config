{ config, lib, pkgs, ... }:
let
  cfg = config.services.configarr;
in with lib; {
  options.services.configarr = {
    enable = lib.mkEnableOption "configarr";

    package = lib.mkPackageOption pkgs "configarr" { };

    dataDir = lib.mkOption {
      type = types.path;
      default = "/var/lib/configarr";
      description = "Appdata location for settings and templates";
    };

    configFile = lib.mkOption {
      type = types.path;
    };

    secretsFile = lib.mkOption {
      type = types.path;
    };

    settings = lib.mkOption {
      type = types.attrs;
      default = { };
      description = "configarr settings";
    };
  };

  config = lib.mkIf cfg.enable {
    systemd.timers.configarr = {
      description = "Configarr";
      wantedBy = [ "timers.target" ];

      timerConfig = {
        OnCalendar = "daily";
        Persistent = "yes";
        AccuracySec = "86400s";
        RandomizedDelaySec = "24h";
        FixedRandomDelay = true;
      };
    };

    systemd.services.configarr = {
      description = "configarr";
      wants = [ "network.target" ];
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];

      environment = {
        ROOT_PATH = cfg.dataDir;
        CONFIG_LOCATION = cfg.configFile;
      };

      serviceConfig = {
        Type = "oneshot";
        ExecStart = lib.getExe cfg.package;
      };
    };
  };
}
