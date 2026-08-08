{ inputs, ... }:

{
  flake.nixosModules.hosts-benedick-disko = {
    imports = with inputs; [
      disko.nixosModules.disko
    ];

    disko.devices = {
      disk = {
        one = {
          type = "disk";
          device = "/dev/nvme0n1";
          content = {
            type = "gpt";
            partitions = {
              ESP = {
                size = "1G";
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
                  # TODO: look at enrollFido2 option over passwordFile
                  passwordFile = "/tmp/passwd";
                  settings.allowDiscards = true;
                  content = {
                    type = "btrfs";
                    extraArgs = [
                      "--force"
                    ];
                    subvolumes =
                      let
                        mountOptions = [
                          "compress=zstd"
                          "noatime"
                        ];
                      in
                      {
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
                          swap.swapfile.size = "16G";
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
  };
}
