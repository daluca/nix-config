{ inputs, ... }:

{
  imports = with inputs; [
    disko.nixosModules.disko
  ];

  disko.devices = {
    disk = {
      nvme = {
        type = "disk";
        device = "/dev/nvme0n1";
        content = {
          type = "gpt";
          partitions = {
            boot = {
              size = "1M";
              type = "EF02";
            };
            ESP = {
              size = "1G";
              type = "EF00";
              priority = 1;
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
                mountOptions = [ "umask=0077" ];
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
                  type = "btrfs";
                  extraArgs = [ "--force" ];
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
                      swap.swapfile.size = "64G";
                    };
                  };
                };
              };
            };
          };
        };
      };
      one = {
        type = "disk";
        device = "/dev/sda";
        content = {
          type = "gpt";
          partitions = {
            data = {
              size = "100%";
              content = {
                type = "luks";
                name = "cryptdata1";
                passwordFile = "/tmp/passwd";
                settings.allowDiscards = true;
              };
            };
          };
        };
      };
      two = {
        type = "disk";
        device = "/dev/sdb";
        content = {
          type = "gpt";
          partitions = {
            data = {
              size = "100%";
              content = {
                type = "luks";
                name = "cryptdata2";
                passwordFile = "/tmp/passwd";
                settings.allowDiscards = true;
                content = {
                  type = "btrfs";
                  extraArgs = [
                    "--force"
                    "--data=single"
                    "--metadata=raid1"
                    "/dev/mapper/cryptdata1"
                  ];
                  subvolumes = {
                    "@storage" = {
                      mountpoint = "/storage";
                      mountOptions = [
                        "compress=zstd"
                        "noatime"
                      ];
                    };
                  };
                };
              };
            };
          };
        };
      };
    };
  };
}
