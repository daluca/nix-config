{ lib, ... }:

{
  boot.loader.systemd-boot = {
    enable = true;
    editor = false;
  };

  boot.loader.efi.canTouchEfiVariables = true;

  boot.loader.grub.enable = lib.mkForce false;
}
