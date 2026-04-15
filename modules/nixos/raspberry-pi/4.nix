{ lib, pkgs, inputs, outputs, ... }:

{
  imports = with inputs; with outputs.nixosModules; [
    raspberry-pi

    raspberry-pi-nix.nixosModules.sd-image
    raspberry-pi-nix.nixosModules.raspberry-pi
  ];

  host.network.interface = "end0";

  raspberry-pi-nix.board = "bcm2711";

  boot.kernelPackages = lib.mkForce pkgs.linuxKernel.packages.linux_rpi4;

  hardware.raspberry-pi.config.all = {
    dt-overlays.disable-bt = {
      enable = true;
      params = { };
    };
  };

  raspberry-pi-nix.libcamera-overlay.enable = false;
}
