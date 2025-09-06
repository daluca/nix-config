{ config, nixos-raspberrypi, ... }:

{
  imports = with nixos-raspberrypi.nixosModules.raspberry-pi-5; [
    base
    display-vc4
    bluetooth
  ];

  system.nixos.tags = let
    cfg = config.boot.loader.raspberryPi;
  in [
    "raspberry-pi-5"
    cfg.bootloader
    config.boot.kernelPackages.kernel.version
  ];
}
