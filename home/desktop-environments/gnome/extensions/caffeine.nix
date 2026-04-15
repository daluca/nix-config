{ pkgs, ... }:

with pkgs.gnomeExtensions; {
  home.packages = [ caffeine ];

  dconf.settings."org/gnome/shell".enabled-extensions = [
    caffeine.extensionUuid
  ];
}
