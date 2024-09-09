{ lib, pkgs, osConfig, ... }:

with pkgs.gnomeExtensions; lib.mkIf osConfig.services.tailscale.enable {
  home.packages = [ tailscale-qs ];

  dconf.settings."org/gnome/shell".enabled-extensions = [
    tailscale-qs.extensionUuid
  ];
}
