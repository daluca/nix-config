{ config, nixos-raspberrypi, ... }:

{
  imports = with nixos-raspberrypi.nixosModules; [
    raspberry-pi-5.base
    raspberry-pi-5.display-vc4
    raspberry-pi-5.bluetooth
  ];

  system.nixos.tags = [
    "raspberry-pi-5"
    config.boot.loader.raspberryPi.bootloader
    config.boot.kernelPackages.kernel.version
  ];
}
