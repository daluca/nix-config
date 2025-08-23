{
  disko.devices = {
    disk = {
      one = {
        type = "disk";
        device = "/dev/sda";
        content = {
          type = "gpt";
          partitions = {
            boot = {
              size = "1M";
              type = "EF02";
            };
            ESP = {
              size = "256M";
              type = "EF00";
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
                mountOptions = [
                  "umask=0077"
                ];
              };
            };
            root = {
              size = "100%";
              content = {
                type = "luks";
                name = "cryptroot";
                passwordFile = "/tmp/passwd";
                settings.allowDiscards = true;
                content = {
                  type = "lvm_pv";
                  vg = "pool";
                };
              };
            };
          };
        };
      };
    };
    lvm_vg = {
      pool = {
        type = "lvm_vg";
        lvs = {
          root = {
            size = "100%";
            content = {
              type = "btrfs";
              extraArgs = [
                "-f"
              ];
              subvolumes = let
                mountOptions = [
                  "compress=zstd"
                  "noatime"
                ];
              in {
                "@rootfs" = {
                  inherit mountOptions;
                  mountpoint = "/";
                };
                "@nix" = {
                  inherit mountOptions;
                  mountpoint = "/nix";
                };
                "@persistent" = {
                  inherit mountOptions;
                  mountpoint = "/persistent";
                };
                "@swap" = {
                  mountpoint = "/var/lib/swap";
                  swap.swapfile.size = "4G";
                };
              };
            };
          };
        };
      };
    };
  };
}
