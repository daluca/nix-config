{ lib, ... }:
let
  GiB = 1024;
in {
  swapDevices = lib.mkForce [
    {
      device = "/var/lib/swap/swapfile";
      size = 16 * GiB;
    }
  ];
}
