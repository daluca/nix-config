{ config, ... }:

{
  boot.loader.efi.canTouchEfiVariables = true;

  boot.loader.grub = {
    enable = true;
    device = "nodev";
    efiSupport = true;
    useOSProber = false;
    default = "saved";
    users = {
      root.hashedPasswordFile = config.sops.secrets."grub/root/hashed-password".path;
    };
    entries = {
      restart = true;
      shutdown = true;
      bios = true;
    };
  };

  sops.secrets."grub/root/hashed-password" = { };
}
