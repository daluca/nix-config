{ config, pkgs, inputs, ... }:
let
  inherit (pkgs) vim;
in {
  imports = [
    inputs.nixos-hardware.nixosModules.raspberry-pi-4

    ./hardware-configuration.nix

    ../../nixos/common
    ../../nixos/openssh-server
  ];

  networking.hostName = "stormwind";

  environment.systemPackages = [
    vim
  ];

  sops.secrets.daluca-password.neededForUsers = true;

  users.mutableUsers = false;
  users.users.daluca = {
    isNormalUser = true;
    hashedPasswordFile = config.sops.secrets.daluca-password.path;
    extraGroups = [ "wheel" ];
  };

  system.stateVersion = "24.05";
}
