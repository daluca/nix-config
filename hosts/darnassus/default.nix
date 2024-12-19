{ config, lib, pkgs, system, ... }:
let
  inherit (lib) mkForce;
  inherit (pkgs) vim;
in {
  imports = [
    ../../images/raspberry-pi/4

    ../../nixos/common
    ../../nixos/openssh-server
  ];

  services.getty.autologinUser = "daluca";

  environment.systemPackages = [
    vim
  ];

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
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIZuHaRedC+s+EbKgGj1ZBQ0tClxgfYt6XVd1grNUgjV daluca@artemis"
    ];
  };

  networking.hostName = "darnassus";

  services.openssh.settings = {
    AllowUsers = mkForce null;
    PermitRootLogin = mkForce "yes";
  };

  hardware.raspberry-pi.config.pi4 = {
    dt-overlays.rpi-poe-plus = {
      enable = true;
      params = {
        poe_fan_temp0 = { enable = true; value = 65 * 1000; };
        poe_fan_temp1 = { enable = true; value = 70 * 1000; };
        poe_fan_temp2 = { enable = true; value = 75 * 1000; };
        poe_fan_temp3 = { enable = true; value = 80 * 1000; };
      };
    };
  };

  system.stateVersion = "24.11";
}
