{
  flake.nixosModules.grub-options =
    { config, lib, ... }:
    let
      cfg = config.boot.loader.grub;
    in
    with lib;
    {
      options.boot.loader.grub = {
        entries = lib.mkOption {
          type = types.submodule {
            options = {
              restart = lib.mkOption {
                type = types.bool;
                default = false;
                description = "Add restart menu entry";
              };

              shutdown = lib.mkOption {
                type = types.bool;
                default = false;
                description = "Add shutdown menu entry";
              };

              bios = lib.mkOption {
                type = types.bool;
                default = false;
                description = "Add BIOS menu entry";
              };
            };
          };
          default = { };
        };
      };

      config = lib.mkIf cfg.enable {
        boot.loader.grub.extraEntries =
          lib.optionalString cfg.entries.restart ''
            menuentry "System restart" {
              echo "System rebooting..."
              reboot
            }
          ''
          + lib.optionalString cfg.entries.shutdown ''
            menuentry "System shutdown" {
              echo "System shutting down..."
              halt
            }
          ''
          + lib.optionalString cfg.entries.bios ''
            menuentry "UEFI Firmware Settings" {
              echo "System rebooting into BIOS..."
              fwsetup
            }
          '';
      };
    };

  flake.nixosModules.grub = { config, ... }: {
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
  };
}
