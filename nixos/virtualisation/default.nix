{ pkgs, ... }:
let
  inherit (pkgs) gnome-boxes;
in {
  virtualisation.libvirtd = {
    enable = true;
  };

  environment.systemPackages = [
    gnome-boxes
  ];
}
