{
  boot.loader.efi.canTouchEfiVariables = true;

  boot.loader.grub = {
    enable = true;
    device = "nodev";
    efiSupport = true;
    useOSProber = false;
    default = "saved";
    extraEntries = /* grub */ ''
      menuentry "System restart" {
              echo "System rebooting..."
              reboot
      }

      menuentry "System shutdown" {
              echo "System shutting down..."
              halt
      }

      menuentry "UEFI Firmware Settings" {
              fwsetup
      }
    '';
  };
}
