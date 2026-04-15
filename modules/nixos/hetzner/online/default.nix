{ config, lib, outputs, ... }:

{
  imports = with outputs.nixosModules; [
    hetzner
  ];

  boot.loader.efi.canTouchEfiVariables = lib.mkForce false;

  boot.loader.grub.efiSupport = lib.mkForce false;

  boot.initrd.systemd.network.networks."10-uplink" = config.systemd.network.networks."10-uplink";

  boot.initrd.availableKernelModules = [
    "e1000e"
  ];
}
