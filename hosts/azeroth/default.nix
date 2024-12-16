{ config, inputs, ... }:

{
  imports = [
    inputs.nixos-hardware.nixosModules.common-cpu-intel
    inputs.disko.nixosModules.disko

    ./disko-btrfs.nix

    ../../nixos/common
    ../../nixos/grub
    ../../nixos/openssh-server
  ];

  networking = {
    hostName = "azeroth";
    hostId = "5c9bd4a2";
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

  system.stateVersion = "24.11";
}
