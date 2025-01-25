{ config, lib, osConfig, ... }:
let
  inherit (lib.hm.gvariant) mkVariant mkTuple mkUint32 mkDouble;
  wellington =
    (mkVariant (mkTuple [
      (mkUint32 2)
      (mkVariant (mkTuple [
        "Wellington"
        "NZWN"
        true
        [ (mkTuple [ (mkDouble "-0.72140275167322543") (mkDouble "3.0508355324860883") ]) ]
        [ (mkTuple [ (mkDouble "-0.720820981073658") (mkDouble "3.050544638459658") ]) ]
      ]))
    ]));
  auckland =
    (mkVariant (mkTuple [
      (mkUint32 2)
      (mkVariant (mkTuple [
        "Auckland"
        "NZAA"
        true
        [ (mkTuple [ (mkDouble "-0.64606271726433173") (mkDouble "3.0508355324860883") ]) ]
        [ (mkTuple [ (mkDouble "-0.64344472338634029") (mkDouble "3.0502537618865206") ]) ]
      ]))
    ]));
  london =
    (mkVariant (mkTuple [
      (mkUint32 2)
      (mkVariant (mkTuple [
        "London"
        "EGWU"
        true
        [ (mkTuple [ (mkDouble "0.89971722940307675") (mkDouble "-0.007272211034407213") ]) ]
        [ (mkTuple [ (mkDouble "0.89884456477707964") (mkDouble "-0.0020362232784242244") ]) ]
      ]))
    ]));
  amsterdam =
    (mkVariant (mkTuple [
      (mkUint32 2)
      (mkVariant (mkTuple [
        "Amsterdam"
        "EHAM"
        true
        [ (mkTuple [ (mkDouble "0.91280719879303418") (mkDouble "0.083194033496160544") ]) ]
        [ (mkTuple [ (mkDouble "0.91402892926943036") (mkDouble "0.085346600422522706") ]) ]
      ]))
    ]));
in {
  imports = [
    ../common
    ./extensions
    ./wallpaper
  ];

  dconf.settings = with lib.hm.gvariant; lib.mkIf osConfig.services.xserver.desktopManager.gnome.enable {
    "org/gnome/mutter" = {
      dynamic-workspaces = true;
      experimental-features = [ "scale-monitor-framebuffer" ];
      edge-tiling = true;
    };
    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
      enable-hot-corners = false;
    };
    "org/gnome/desktop/peripherals/keyboard" = {
      numlock-state = true;
    };
    "org/gnome/settings-daemon/plugins/color" = {
      night-light-enabled = true;
    };
    "org/gnome/GWeather4" = {
      temperature-unit = "centigrade";
    };
    "org/gnome/Weather" = {
      locations = [ wellington auckland london amsterdam ];
    };
    "org/gnome/shell/weather" = {
      locations = [ wellington auckland london amsterdam ];
    };
    "org/gnome/clocks" = {
      world-clocks = [
        [ (mkDictionaryEntry [ "location" wellington ]) ]
        [ (mkDictionaryEntry [ "location" auckland ]) ]
        [ (mkDictionaryEntry [ "location" london ]) ]
        [ (mkDictionaryEntry [ "location" amsterdam ]) ]
      ];
    };
    "org/gnome/shell/world-clocks" = {
      locations = [ wellington auckland london amsterdam ];
    };
  };

  systemd.user.tmpfiles.rules = [
    "L+ /home/${config.home.username}/.config/monitors.xml - - - - ${./monitors.xml}"
  ];
}
