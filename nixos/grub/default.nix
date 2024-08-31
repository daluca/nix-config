{ ... }:

{
  boot.loader.efi.canTouchEfiVariables = true;

  boot.loader.grub = {
    enable = true;
    device = "nodev";
    efiSupport = true;
    useOSProber = true;
    default = "saved";
    extraEntries = ''
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
