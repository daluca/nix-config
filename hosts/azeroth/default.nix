{ config, lib, inputs, ... }:
let
  inherit (lib) mkForce;
in {
  imports = [
    inputs.nixos-hardware.nixosModules.common-cpu-intel
    inputs.disko.nixosModules.disko

    ./disko.nix

    ../../nixos/common
    ../../nixos/grub
    ../../nixos/openssh-server
  ];

  networking = {
    hostName = "azeroth";
    hostId = "5c9bd4a2";
  };

  boot.initrd.systemd.emergencyAccess = config.user.users.root.hashedPassword;

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

  users.users.root = {
    hashedPassword = "$6$DEeqjCJ0NmLMM1Zr$8uUBcuWM2GHeQhuI6dN.nbL0PP/6nHu1P1hPIhP3mNdd0KPBO/dpIv0N8y6m1Uyr9k4jp9gVbDJCQBh1ejj/e/";
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIZuHaRedC+s+EbKgGj1ZBQ0tClxgfYt6XVd1grNUgjV daluca@artemis"
    ];
  };

  services.openssh.settings = {
    AllowUsers = mkForce null;
    PermitRootLogin = mkForce "yes";
  };

  system.stateVersion = "24.11";
}
