{ pkgs, inputs, ... }:
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

  users.mutableUsers = true;
  users.users.daluca = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
  };

  system.stateVersion = "24.05";
}
