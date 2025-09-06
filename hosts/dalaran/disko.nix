{
  disko.devices = {
    disk = {
      one = {
        type = "disk";
        device = "/dev/nvme0n1";
        content = {
          type = "gpt";
          partitions = {
            FIRMWARE = {
              priority = 1;
              type = "0700";
              label = "FIRMWARE";
              size = "1024M";
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot/firmware";
                mountOptions = [
                  "noatime"
                ];
              };
            };
            ESP = {
              type = "EF00";
              label = "ESP";
              size = "1024M";
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
                mountOptions = [
                  "noatime"
                  "umask=0077"
                ];
              };
            };
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
                  "@storage" = {
                    inherit mountOptions;
                    mountpoint = "/storage";
                  };
                };
              };
            };
            swap = {
              size = "16G";
              content = {
                type = "swap";
                randomEncryption = true;
                priority = 100;
              };
            };
          };
        };
      };
    };
  };
}
