{ config, pkgs, ... }:

{
  home.packages = with pkgs.gnomeExtensions; [ caffeine ];

  dconf.settings."org/gnome/shell".enabled-extensions = [ "caffeine@patapon.info" ];
}
