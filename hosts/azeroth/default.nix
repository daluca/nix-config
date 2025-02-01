{ config, inputs, ... }:

{
  imports = [
    inputs.nixos-hardware.nixosModules.common-cpu-intel
    inputs.disko.nixosModules.disko

    ./disko.nix

    ../../nixos/common
    ../../nixos/grub
    ../../nixos/openssh-server
    ../../users/root
    ../../users/daluca
  ];

  networking = {
    hostName = "azeroth";
    hostId = "5c9bd4a2";
  };

  boot.initrd.systemd.emergencyAccess = config.user.users.root.hashedPassword;

  system.stateVersion = "24.11";
}
