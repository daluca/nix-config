{ pkgs, ... }:

with pkgs.gnomeExtensions; {
  dconf.settings."org/gnome/shell".enabled-extensions = [ appindicator.extensionUuid ];
}
