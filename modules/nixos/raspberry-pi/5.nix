{ config, inputs, outputs, ... }:

{
  imports = with inputs; with outputs.nixosModules; [
    raspberry-pi

    nixos-raspberrypi.nixosModules.raspberry-pi-5.base
    nixos-raspberrypi.nixosModules.raspberry-pi-5.display-vc4
    nixos-raspberrypi.nixosModules.raspberry-pi-5.bluetooth
  ];

  system.nixos.tags = with config.boot.loader; with config.boot.kernelPackages; [
    "raspberry-pi-5"
    raspberry-pi.bootloader
    kernel.version
  ];

  boot.loader.raspberry-pi.bootloader = "kernel";
}
