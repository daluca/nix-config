{ config, lib, pkgs, ... }:
let
  inherit (lib) mkEnableOption mkPackageOption mkOption mkIf types;
  cfg = config.programs.proton-bridge;
in {
  options.programs.proton-bridge = {
    enable = mkEnableOption "Proton Mail Bridge application";

    package = mkPackageOption pkgs "protonmail-bridge" { };

    logLevel = mkOption {
      type = types.enum [
        "panic"
        "fatal"
        "error"
        "warn"
        "info"
        "debug"
      ];
      default = "info";
      description = "Set log level";
    };

    nonInteractive = mkOption {
      type = types.bool;
      default = true;
      description = "Start proton-bridge non interactively";
    };
  };

  config = mkIf cfg.enable {
    home.packages = [ cfg.package ];

    systemd.user.services.proton-bridge = {
      Unit = {
        Description = "Proton Bridge";
        After = [ "network.target" ];
      };

      Service = {
        Restart = "always";
        ExecStart = "${cfg.package}/bin/protonmail-bridge --log-level ${cfg.logLevel}" + lib.optionalString cfg.nonInteractive " --noninteractive";
        Environment = [
          "PATH=${pkgs.gnome-keyring}/bin"
        ];
      };

      Install = {
        WantedBy = [ "default.target" ];
      };
    };
  };
}
