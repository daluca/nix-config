{ lib, pkgs, ... }:

with pkgs.gnomeExtensions; {
  home.packages = [ paperwm ];

  dconf.settings = with lib.hm.gvariant; {
    "org/gnome/shell".enabled-extensions = [
      paperwm.extensionUuid
    ];
    "org/gnome/shell/extensions/paperwm" = {
      show-window-position-bar = false;
      selection-border-radius-bottom = 12;
      window-gap = 10;
      horizontal-margin = 5;
      vertical-margin = 5;
      vertical-margin-bottom = 5;
      minimap-scale = mkDouble "0.0";
    };
  };

  home.persistence.home.directories = [
    ".config/paperwm"
  ];
}
