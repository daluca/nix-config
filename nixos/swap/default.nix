{ lib, ... }:

{
  swapDevices = lib.mkForce [{
    # TODO: Replace with btrfs swap volume
    device = "/var/lib/swapfile";
    size = 8 * 1024;
  }];
}
