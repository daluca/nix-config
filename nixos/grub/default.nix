{
  boot.loader.efi.canTouchEfiVariables = true;

  boot.loader.grub = {
    enable = true;
    device = "nodev";
    efiSupport = true;
    useOSProber = false;
    default = "saved";
    entries = {
      restart = true;
      shutdown = true;
      bios = true;
    };
  };
}
