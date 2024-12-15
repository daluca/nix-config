let
  zfs-disk = device: pool: {
    type = "disk";
    device = device;
    content = {
      type = "gpt";
      partitions.zfs = {
        size = "100%";
        content = {
          type = "zfs";
          pool = pool;
        };
      };
    };
  };
  storage = "tank";
in {
  disko.devices = {
    disk = {
      nvme = {
        type = "disk";
        device = "/dev/nvme0n1";
        content = {
          type = "gpt";
          partitions = {
            ESP = {
              size = "64M";
              type = "EF00";
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
                type = "btrfs";
                extraArgs = [ "-f" ];
                mountpoint = "/";
                mountOptions = [ "compress=zstd" "noatime" ];
              };
            };
          };
        };
      };
      data0 = zfs-disk "/dev/sda" storage;
      data1 = zfs-disk "/dev/sdb" storage;
    };
    zpool = {
      ${storage} = {
        type = "zpool";
        mountpoint = "/${storage}";
        mode = "mirror"; # raid2
        options = {
          compression = "lz4";
        };
      };
    };
  };
}
