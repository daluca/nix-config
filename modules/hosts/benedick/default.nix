{ self, inputs, ... }:

{
  flake.nixosConfigurations.benedick = inputs.nixpkgs.lib.nixosSystem {
    system = "x86_64-linux";
    modules = with self.nixosModules; [
      hosts-benedick
    ];
  };

  flake.nixosModules.hosts-benedick = { lib, ... }: {
    imports =
      with inputs;
      with self.nixosModules;
      [
        nixos-hardware.nixosModules.common-cpu-amd
        nixos-hardware.nixosModules.common-gpu-amd
        nixos-hardware.nixosModules.common-pc
        nixos-hardware.nixosModules.common-pc-ssd

        desktop
        hosts-benedick-disko

        keychron
        logitech
        nix-monitored
        pipewire
        plymouth
        systemd-boot
        yubikey

        fonts
        ssh-server
        distributedBuilds
        firewall
        fwupd
        steam
        gnome
        impermanence
        gsconnect
      ];

    sops.defaultSopsFile = ../../hosts/benedick/benedick.sops.yaml;

    home-manager.users.daluca.imports = with self.homeManagerModules; [
      users-daluca-benedick
    ];

    networking.hostName = "benedick";

    environment.etc."xdg/monitors.xml".source = ./monitors.xml;

    zramSwap.enable = true;

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

    system.stateVersion = "26.05";
  };
}
