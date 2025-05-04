{ lib, inputs, ... }:

{
  imports = [
    inputs.nixos-hardware.nixosModules.lenovo-thinkpad-x1-7th-gen
    inputs.nixos-hardware.nixosModules.common-cpu-intel

    ./hardware-configuration.nix
  ] ++ map (m: lib.custom.relativeToHosts m) [
    "."
  ] ++ map (m: lib.custom.relativeToNixosModules m) [
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
    "nvidia"
    "steam"
    "docker"
    "smart-cards"
    "tailscale"
    "kanata"
    "gaming"
    "virtualisation"
    "battery"
  ];

  networking.hostName = "artemis";

  time.timeZone = lib.mkForce "Europe/Amsterdam";

  nix.settings.warn-dirty = false;

  sops.secrets."ssh_host_ed25519_key".sopsFile = ./artemis.sops.yaml;

  sops.secrets."ssh_host_rsa_key".sopsFile = ./artemis.sops.yaml;

  sops.secrets."tailscale/preauthkey".sopsFile = ./artemis.sops.yaml;

  sops.secrets."proton-bridge/password".sopsFile = ./artemis.sops.yaml;

  fileSystems."/persistent".neededForBoot = true;

  boot.loader.grub.useOSProber = lib.mkForce true;

  boot.binfmt.emulatedSystems = [ "aarch64-linux" ];

  system.stateVersion = "24.11";
}
