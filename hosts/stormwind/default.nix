{ config, pkgs, inputs, ... }:
let
  inherit (pkgs) vim libraspberrypi raspberrypifw;
in {
  imports = [
    inputs.nixos-hardware.nixosModules.raspberry-pi-4

    ./hardware-configuration.nix

    ../../nixos/common
    ../../nixos/openssh-server
    ../../nixos/adguardhome
    ../../nixos/tailscale/server
  ];

  networking.hostName = "stormwind";

  environment.systemPackages = [
    vim
    libraspberrypi
    # raspberrypifw
  ];

  hardware.raspberry-pi."4".poe-hat.enable = true;

  sops.secrets."tailscale/preauthkey" = {
    sopsFile = ../../secrets/stormwind.sops.yaml;
  };

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

  system.stateVersion = "24.05";
}
