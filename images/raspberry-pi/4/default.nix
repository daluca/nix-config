{ lib, pkgs, ... }:

{
  imports = [
    ../common.nix
  ];

  raspberry-pi-nix.board = "bcm2711";

  boot.kernelPackages = lib.mkForce pkgs.linuxKernel.packages.linux_rpi4;
}
