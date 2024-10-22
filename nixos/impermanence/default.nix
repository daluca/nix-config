{ config, lib, inputs, ... }:
let
  inherit (lib) mkIf mkAfter;
in {
  imports = [
    inputs.impermanence.nixosModules.impermanence

    ./sudo.nix
    ./bluetooth.nix
    ./openssh.nix
    ./secrets.nix
    ./tailscale.nix
  ];

  programs.fuse.userAllowOther = mkIf config.home-manager.users.daluca.home.persistence.home.allowOther true;

  environment.persistence.system = {
    persistentStoragePath = "/persistent/system";
    hideMounts = true;
    directories = [
      "/etc/nixos"
      "/var/log"
      "/var/lib/nixos"
      "/etc/NetworkManager/system-connections"
    ];
    files = [
      "/etc/machine-id"
    ];
  };

  boot.initrd.postDeviceCommands = mkIf ( config.fileSystems."/".fsType == "btrfs" ) (mkAfter /* bash */ ''
    mkdir /btrfs_tmp
    mount /dev/root_vg/root /btrfs_tmp
    if [[ -e /btrfs_tmp/root ]]; then
      mkdir -p /btrfs_tmp/old_roots
      timestamp=$(date --date="@$(stat -c %Y /btrfs_tmp/root)" "+%Y-%m-%-d_%H:%M:%S")
      mv /btrfs_tmp/root "/btrfs_tmp/old_roots/$timestamp"
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

    for i in $(find /btrfs_tmp/old_roots/ -maxdepth 4 -path "*/var/lib/*" -name "swapfile"); do
      rm "$i"
    done

    btrfs subvolume create /btrfs_tmp/root
    umount /btrfs_tmp
  '');
}
