{ pkgs, ... }:

with pkgs.gnomeExtensions; {
  home.packages = [ gsconnect ];

  dconf.settings."org/gnome/shell".enabled-extensions = [
    gsconnect.extensionUuid
  ];
}
