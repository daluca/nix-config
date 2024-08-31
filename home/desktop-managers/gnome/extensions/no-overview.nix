{ pkgs, ... }:

with pkgs.gnomeExtensions; {
  home.packages = [ no-overview ];

  dconf.settings."org/gnome/shell".enabled-extensions = [
    no-overview.extensionUuid
  ];
}
