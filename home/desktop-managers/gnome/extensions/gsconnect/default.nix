{ config, lib, pkgs, ... }:
let
  inherit (pkgs.gnomeExtensions) gsconnect;
  inherit (config.xdg) configHome;
  inherit (lib.hm.gvariant) mkDictionaryEntry mkTuple;
  zenphone-10 = "1585fe42_d731_4e18_a83b_2f420174b038";
in {
  home.packages = [ gsconnect ];

  dconf.settings = {
    "org/gnome/shell".enabled-extensions = [
      gsconnect.extensionUuid
    ];
    "org/gnome/shell/extensions/gsconnect" = {
      enabled = true;
      devices = [
        zenphone-10
      ];
    };
    "org/gnome/shell/extensions/gsconnect/device/${zenphone-10}" = {
      paired = true;
      certificate-pem = builtins.readFile ./zenphone-10.pem;
      disabled-plugins = mkTuple [ ];
    };
    "org/gnome/shell/extensions/gsconnect/device/${zenphone-10}/plugin/clipboard" = {
      send-content = true;
      recieve-content = true;
    };
    # TODO: Get GSConnect to work with setting
    "org/gnome/shell/extensions/gsconnect/device/${zenphone-10}/plugin/notifications".applications = builtins.toJSON {
      Power = {
        iconName = "org.gnome.Settings-power-symbolic";
        enabled = true;
      };
      Clocks = {
        iconName = "org.gnome.clocks";
        enabled = true;
      };
      "File Roller" = {
        iconName = "org.gnome.FileRoller";
        enabled = true;
      };
      Printers = {
        iconName = "org.gnome.Settings-printers-symbolic";
        enabled = true;
      };
      "Disk Usage Analyzer" = {
        iconName = "org.gnome.baobab";
        enabled = true;
      };
      Files = {
        iconName = "org.gnome.Nautilus";
        enabled = true;
      };
      Disks = {
        iconName = "org.gnome.DiskUtility";
        enabled = true;
      };
      "Events and Tasks Reminders" = {
        iconName = "org.gnome.Evolution-alarm-notify";
        enabled = true;
      };
      Console = {
        iconName = "org.gnome.Console";
        enabled = true;
      };
      Geary = {
        iconName = "org.gnome.Geary";
        enabled = true;
      };
      "Date & Time" = {
        iconName = "org.gnome.Settings-time-symbolic";
        enabled = true;
      };
    };
  };

  xdg.configFile."gsconnect/certificate.pem".source = ./certificate.pem;
  sops.secrets."gsconnect/private.pem".path = "${configHome}/gsconnect/private.pem";
}
