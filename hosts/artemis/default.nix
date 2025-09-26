{ lib, inputs, ... }:

{
  imports = with inputs; [
    nixos-hardware.nixosModules.lenovo-thinkpad-x1-7th-gen
    nixos-hardware.nixosModules.common-cpu-intel

    ./hardware-configuration.nix
  ] ++ map (m: lib.custom.relativeToHosts m) [
    "."
  ] ++ map (m: lib.custom.relativeToNixosModules m) [
    "auto-cpufreq"
    "desktop-managers/gnome"
    "swap"
    "ssd"
    "pipewire"
    "impermanence"
    "fonts"
    "firewall"
    "thinkfan"
    "grub"
    "fwupd"
    "steam"
    "docker"
    "smart-cards"
    "tailscale"
    "kanata"
    "battery"
    "distributed-builds"
  ];

  networking.hostName = "artemis";

  time.timeZone = "Europe/Amsterdam";

  nix.settings = {
    warn-dirty = false;
    substituters = [ "https://nixos-raspberrypi.cachix.org" ];
    trusted-public-keys = [ "nixos-raspberrypi.cachix.org-1:4iMO9LXa8BqhU+Rpg6LQKiGa2lsNh/j2oiYLNOQ5sPI=" ];
  };

  host.battery = true;

  networking.localCommands = /* bash */ ''
    ip rule add to 192.168.178.0/24 priority 2500 lookup main || true
  '';

  sops.secrets."ssh_host_ed25519_key".sopsFile = ./artemis.sops.yaml;

  sops.secrets."ssh_host_rsa_key".sopsFile = ./artemis.sops.yaml;

  sops.secrets."tailscale/preauthkey".sopsFile = ./artemis.sops.yaml;

  sops.secrets."proton-bridge/password".sopsFile = ./artemis.sops.yaml;

  boot.initrd.postResumeCommands = lib.mkForce (lib.mkAfter /* bash */ ''
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

    btrfs subvolume create /btrfs_tmp/root
    umount /btrfs_tmp
  '');

  boot.loader.grub.useOSProber = lib.mkForce true;

  boot.binfmt.emulatedSystems = [ "aarch64-linux" ];

  system.stateVersion = "25.05";
}
