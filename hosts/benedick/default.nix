{
  lib,
  inputs,
  ...
}:

{
  imports =
    with inputs;
    with self.nixosModules;
    [
      ./..
      ./disko.nix

      nixos-hardware.nixosModules.common-cpu-amd
      nixos-hardware.nixosModules.common-gpu-amd
      nixos-hardware.nixosModules.common-pc
      nixos-hardware.nixosModules.common-pc-ssd

      keychron
      logitech
      nix-monitored
      pipewire
      plymouth
      systemd-boot
      yubikey
    ]
    ++ map (m: lib.custom.relativeToNixosModules m) [
      "desktop-environments/gnome"
      "distributed-builds"
      "firewall"
      "fonts"
      "fwupd"
      "impermanence"
      "kanata"
      "openssh/server"
      "smart-cards"
      "steam"
    ];

  networking.hostName = "benedick";

  time.timeZone = "Europe/Amsterdam";

  environment.etc."xdg/monitors.xml".source = lib.mkForce ./monitors.xml;

  nix.settings = {
    warn-dirty = false;
    substituters = [
      "https://nixos-raspberrypi.cachix.org?priority=100"
    ];
    trusted-public-keys = [
      "nixos-raspberrypi.cachix.org-1:4iMO9LXa8BqhU+Rpg6LQKiGa2lsNh/j2oiYLNOQ5sPI="
    ];
  };

  hardware.enableRedistributableFirmware = true;

  boot.initrd.luks.devices.cryptroot.crypttabExtraOpts = [
    "fido2-device=auto"
    "token-timeout=5s"
  ];

  boot.initrd.systemd.emergencyAccess = true;

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

  boot.binfmt.emulatedSystems = [ "aarch64-linux" ];

  system.stateVersion = "26.05";
}
