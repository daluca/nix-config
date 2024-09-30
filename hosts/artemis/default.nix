{ config, inputs, ... }:

{
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
    ../../nixos/openssh-server
    ../../nixos/nvidia
    ../../nixos/networking

    ../../nixos/steam
    # ../../nixos/opensnitch
    ../../nixos/docker
    ../../nixos/smart-cards
    ../../nixos/tailscale
  ];

  networking.hostName = "artemis";

  nix.settings.warn-dirty = false;

  sops.secrets.daluca-password.neededForUsers = true;

  users.mutableUsers = false;
  users.users.daluca = {
    isNormalUser = true;
    hashedPasswordFile = config.sops.secrets.daluca-password.path;
    extraGroups = [ "wheel" ];
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIZuHaRedC+s+EbKgGj1ZBQ0tClxgfYt6XVd1grNUgjV daluca@artemis"
    ];
  };

  fileSystems."/persistent".neededForBoot = true;

  system.stateVersion = "24.05";
}
