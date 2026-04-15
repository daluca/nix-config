{ lib, outputs, ... }:

{
  imports = with outputs.nixosModules; [
    hetzner
  ];

  boot.growPartition = lib.mkImageMediaOverride false;

  services.cloud-init.enable = false;

  networking.useDHCP = lib.mkForce true;

  host.network.interface = "enp1s0";
}
