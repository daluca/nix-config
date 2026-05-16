{
  config,
  lib,
  pkgs,
  ...
}:
let
  root = config.fileSystems."/";
in
{
  imports = [
    ./sudo.nix
    ./bluetooth.nix
    ./openssh.nix
    ./secrets.nix
    ./tailscale.nix
    ./overrides.nix
  ];

  fileSystems."/persistent".neededForBoot = true;

  environment.persistence.system.enable = true;

  environment.persistence.system = {
    persistentStoragePath = "/persistent/system";
    hideMounts = true;
    directories = [
      "/etc/nixos"
      "/var/log"
      "/var/lib/nixos"
      "/var/lib/systemd/coredump"
      "/var/lib/systemd/timers"
    ];
    files = [
      "/etc/machine-id"
    ];
  };

  boot.initrd.systemd = lib.mkIf (root.fsType == "btrfs") {
    services.impermanence = {
      description = "Archiving existing BTRFS root subvolume and creating a fresh one";
      unitConfig.defaultDependencies = false;
      serviceConfig.Type = "oneshot";
      requiredBy = [ "initrd.target" ];
      before = [ "sysroot.mount" ];
      requires = [ "initrd-root-device.target" ];
      after = [
        "initrd-root-device.target"
        "local-fs-pre.target"
      ];

      script = /* bash */ ''
        mkdir /btrfs_tmp
        mount /dev/pool/root /btrfs_tmp
        if [[ -e /btrfs_tmp/@rootfs ]]; then
          mkdir -p /btrfs_tmp/old_roots
          TIMESTAMP=$(date --date="@$(stat -c %Y /btrfs_tmp/@rootfs)" "+%Y-%m-%-d_%H:%M:%S")
          mv /btrfs_tmp/@rootfs "/btrfs_tmp/old_roots/''${TIMESTAMP}"
        fi

        delete_subvolume_recursively() {
          IFS=$'\n'
          for i in $(btrfs subvolume list -o "$1" | cut -f 9- -d ' '); do
              delete_subvolume_recursively "/btrfs_tmp/$i"
          done
          btrfs subvolume delete "$1"
        }

        for i in $(find /btrfs_tmp/old_roots/ -maxdepth 1 -mtime +30); do
          delete_subvolume_recursively "$i"
        done

        btrfs subvolume create /btrfs_tmp/@rootfs
        umount /btrfs_tmp
      '';
    };

    extraBin = {
      mkdir = "${pkgs.coreutils}/bin/mkdir";
      date = "${pkgs.coreutils}/bin/date";
      stat = "${pkgs.coreutils}/bin/stat";
      mv = "${pkgs.coreutils}/bin/mv";
      find = "${pkgs.findutils}/bin/find";
      btrfs = "${pkgs.btrfs-progs}/bin/btrfs";
    };
  };
}
