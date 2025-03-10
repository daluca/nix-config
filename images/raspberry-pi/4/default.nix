{ lib, pkgs, ... }:

{
  imports = map (m: lib.custom.relativeToRoot m) [
    "images/raspberry-pi"
  ];

  raspberry-pi-nix.board = "bcm2711";

  boot.kernelPackages = lib.mkForce pkgs.linuxKernel.packages.linux_rpi4;
}
