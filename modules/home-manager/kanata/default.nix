{ config, lib, pkgs, ... }:
let
  cfg = config.services.kanata;

  configFile = pkgs.writeTextFile {
    name = "config.kdb";
    text = cfg.settings;
    checkPhase = ''
      ${lib.getExe cfg.package} --cfg "$target" --check --debug
    '';
  };
in {
  options.services.kanata = with lib; {
    enable = lib.mkEnableOption "Kanata, Improve keyboard comfort and usability with advanced customization";

    package = lib.mkPackageOption pkgs "kanata" { };

    settings = lib.mkOption {
      type = types.str;
      default = /* list */ ''
        ()
      '';
      description = "Kanata config file";
    };
  };

  config = lib.mkIf cfg.enable  {
    systemd.user.services.kanata = {
      Unit = {
        Description = "Kanata keyboard remapper";
        Documentation = "https://github.com/jtroo/kanata";
      };

      Service = {
        Type = "simple";
        ExecStart = "${lib.getExe cfg.package} --cfg ${configFile}";
        Restart = "no";
      };

      Install = {
        WantedBy = [ "default.target" ];
      };
    };
  };
}
