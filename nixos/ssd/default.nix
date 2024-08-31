{ config, lib, ... }:

{
  services.fstrim.enable = true;

  boot.initrd.luks.devices.cryptroot.allowDiscards = lib.mkIf (config.boot.initrd.luks.devices.cryptroot.device != null) true;
}
