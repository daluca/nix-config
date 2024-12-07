{ config, lib, pkgs, ... }:
let
  inherit (pkgs.gnomeExtensions) gsconnect;
  inherit (config.xdg) configHome;
  inherit (config.home) homeDirectory;
  inherit (lib.hm.gvariant) mkTuple mkUint32;
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
      type = "phone";
      paired = true;
      certificate-pem = builtins.readFile ./zenphone-10.pem;
      disabled-plugins = mkTuple [ ];
      incoming-capabilities = [
        "kdeconnect.battery"
        "kdeconnect.bigscreen.stt"
        "kdeconnect.clipboard"
        "kdeconnect.clipboard.connect"
        "kdeconnect.contacts.request_all_uids_timestamps"
        "kdeconnect.contacts.request_vcards_by_uid"
        "kdeconnect.findmyphone.request"
        "kdeconnect.mousepad.keyboardstate"
        "kdeconnect.mousepad.request"
        "kdeconnect.mpris"
        "kdeconnect.mpris.request"
        "kdeconnect.notification"
        "kdeconnect.notification.action"
        "kdeconnect.notification.reply"
        "kdeconnect.notification.request"
        "kdeconnect.ping"
        "kdeconnect.runcommand"
        "kdeconnect.sftp.request"
        "kdeconnect.share.request"
        "kdeconnect.share.request.update"
        "kdeconnect.sms.request"
        "kdeconnect.sms.request_attachment"
        "kdeconnect.sms.request_conversation"
        "kdeconnect.sms.request_conversations"
        "kdeconnect.systemvolume"
        "kdeconnect.telephony.request"
        "kdeconnect.telephony.request_mute"
      ];
      outgoing-capabilities = [
        "kdeconnect.battery"
        "kdeconnect.bigscreen.stt"
        "kdeconnect.clipboard"
        "kdeconnect.clipboard.connect"
        "kdeconnect.connectivity_report"
        "kdeconnect.contacts.response_uids_timestamps"
        "kdeconnect.contacts.response_vcards"
        "kdeconnect.findmyphone.request"
        "kdeconnect.mousepad.echo"
        "kdeconnect.mousepad.keyboardstate"
        "kdeconnect.mousepad.request"
        "kdeconnect.mpris"
        "kdeconnect.mpris.request"
        "kdeconnect.notification"
        "kdeconnect.notification.request"
        "kdeconnect.ping"
        "kdeconnect.presenter"
        "kdeconnect.runcommand.request"
        "kdeconnect.sftp"
        "kdeconnect.share.request"
        "kdeconnect.sms.attachment_file"
        "kdeconnect.sms.messages"
        "kdeconnect.systemvolume.request"
        "kdeconnect.telephony"
      ];
      supported-plugins = mkTuple [
        "battery"
        "clipboard"
        "connectivity_report"
        "contacts"
        "findmyphone"
        "mousepad"
        "mpris"
        "notification"
        "ping"
        "presenter"
        "runcommand"
        "sftp"
        "share"
        "sms"
        "systemvolume"
        "telephony"
      ];
    };
    "org/gnome/shell/extensions/gsconnect/device/${zenphone-10}/plugin/battery" = {
      custom-battery-notification-value = mkUint32 80;
    };
    "org/gnome/shell/extensions/gsconnect/device/${zenphone-10}/plugin/clipboard" = {
      recieve-content = true; # spellchecker:disable-line
      send-content = true;
    };
    "org/gnome/shell/extensions/gsconnect/device/${zenphone-10}/plugin/notification" = {
      applications = builtins.toJSON {
        Power = {
          iconName = "org.gnome.Settings-power-symbolic";
          enabled = true;
        };
        Clocks = {
          iconName = "org.gnome.clocks";
          enabled = true;
        };
        Color = {
          iconName = "org.gnome.Settings-color-symbolic";
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
        Console = {
          iconName = "org.gnome.Console";
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
        "Date & Time" = {
          iconName = "org.gnome.Settings-time-symbolic";
          enabled = true;
        };
      };
    };
    "org/gnome/shell/extensions/gsconnect/device/${zenphone-10}/plugin/share" = {
      receive-directory = "${homeDirectory}/Downloads";
    };
  };

  xdg.configFile."gsconnect/certificate.pem".source = ./certificate.pem;
  sops.secrets."gsconnect/private.pem".path = "${configHome}/gsconnect/private.pem";
}
