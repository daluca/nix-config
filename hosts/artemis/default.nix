{ lib, inputs, ... }:
let
  inherit (lib) mkForce;
in {
  imports = [
    inputs.nixos-hardware.nixosModules.lenovo-thinkpad-x1-7th-gen
    inputs.nixos-hardware.nixosModules.common-cpu-intel

    ./hardware-configuration.nix
    ../../nixos/swap
    ../../nixos/ssd

    ../../nixos/common
    ../../nixos/desktop-managers/gnome
    ../../nixos/pipewire
    ../../nixos/impermanence
    ../../nixos/fonts
    ../../nixos/firewall
    ../../nixos/thinkfan
    ../../nixos/grub
    ../../nixos/fwupd
    ../../nixos/nvidia
    ../../nixos/distributed-builds
    ../../nixos/steam
    # ../../nixos/opensnitch
    ../../nixos/docker
    ../../nixos/smart-cards
    ../../nixos/tailscale
    ../../nixos/kanata
    ../../nixos/gaming
  ];

  networking.hostName = "artemis";

  nix.settings.warn-dirty = false;

  sops.secrets."tailscale/preauthkey".sopsFile = ./artemis.sops.yaml;

  sops.secrets."proton-bridge/password".sopsFile = ./artemis.sops.yaml;

  fileSystems."/persistent".neededForBoot = true;

  boot.loader.grub.useOSProber = mkForce true;

  boot.binfmt.emulatedSystems = [ "aarch64-linux" ];

  system.stateVersion = "24.11";
}
