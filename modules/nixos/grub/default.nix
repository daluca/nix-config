{ config, lib, ... }:
let
  cfg = config.boot.loader.grub;
in with lib; {
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
    };
  };

  config = lib.mkIf cfg.enable {
    boot.loader.grub.extraEntries = lib.optionalString cfg.entries.restart ''
      menuentry "System restart" {
        echo "System rebooting..."
        reboot
      }
    '' + lib.optionalString cfg.entries.shutdown ''
      menuentry "System shutdown" {
        echo "System shutting down..."
        halt
      }
    '' + lib.optionalString cfg.entries.bios ''
      menuentry "UEFI Firmware Settings" {
        echo "System rebooting into BIOS..."
        fwsetup
      }
    '';
  };
}
