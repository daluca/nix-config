{
  pkgs,
  lib,
  inputs,
  ...
}:

{
  imports =
    with inputs;
    [
      ./..
      ./disko.nix

      nixos-hardware.nixosModules.common-cpu-amd
      nixos-hardware.nixosModules.common-gpu-amd
      nixos-hardware.nixosModules.common-pc
      nixos-hardware.nixosModules.common-pc-ssd
      (nixos-hardware + "/common/wifi/mediatek/mt7925")
      (nixos-hardware + "/common/wifi/mediatek/mt7925/iwd.nix")
    ]
    ++ map (m: lib.custom.relativeToNixosModules m) [
      "desktop-environments/gnome"
      "firewall"
      "fonts"
      "fwupd"
      "impermanence"
      "kanata"
      "keychron"
      "logitech"
      "openssh/server"
      "plymouth"
      "steam"
      "systemd-boot"
    ];

  networking.hostName = "benedick";

  time.timeZone = "Europe/Amsterdam";


  networking.wireless.iwd.settings = {
    DriverQuirks.PowerSaveDisable = "mt7925e";
  };

  environment.etc."xdg/monitors.xml".source = lib.mkForce ./monitors.xml;

  boot.initrd.luks.devices.cryptroot.crypttabExtraOpts = [
    "tpm2-device=auto"
    "token-timeout=5s"
  ];

  boot.initrd.systemd.emergencyAccess = true;

  boot.kernelPackages = pkgs.linuxPackages_latest;

  boot.initrd.systemd.services.impermanence.script = lib.mkForce /* bash */ ''
    mkdir /btrfs_tmp
    mount /dev/mapper/cryptroot /btrfs_tmp
    if [[ -e /btrfs_tmp/@rootfs ]]; then
      mkdir -p /btrfs_tmp/@old_roots
      TIMESTAMP=$(date --date="@$(stat -c %Y /btrfs_tmp/@rootfs)" "+%Y-%m-%-d_%H:%M:%S")
      mv /btrfs_tmp/@rootfs "/btrfs_tmp/@old_roots/''${TIMESTAMP}"
    fi

    delete_subvolume_recursively() {
      IFS=$'\n'
      for i in $(btrfs subvolume list -o "$1" | cut -f 9- -d ' '); do
        delete_subvolume_recursively "/btrfs_tmp/$i"
      done
      btrfs subvolume delete "$1"
    }

    for i in $(find /btrfs_tmp/@old_roots/ -maxdepth 1 -mtime +30); do
      delete_subvolume_recursively "$i"
    done

    btrfs subvolume create /btrfs_tmp/@rootfs
    umount /btrfs_tmp
  '';

  system.stateVersion = "26.05";
}
