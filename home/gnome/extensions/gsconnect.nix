{ config, pkgs, ... }:

{
  home.packages = with pkgs.gnomeExtensions; [ gsconnect ];
  
  dconf.settings."org/gnome/shell".enabled-extensions = [ "gsconnect@andyholmes.github.io" ];
}
