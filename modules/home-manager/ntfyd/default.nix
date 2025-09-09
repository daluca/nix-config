{ config, lib, pkgs, ... }:
let
  cfg = config.services.ntfyd;
in {
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
        ExecStart = "${lib.getExe cfg.package} --server ${cfg.server} " + lib.optionalString (cfg.token != "") "--token ${cfg.token} " + "${builtins.concatStringsSep " " cfg.topics}";
        Restart = "always";
      };

      Install = {
        WantedBy = [ "default.target" ];
      };
    };
  };
}
