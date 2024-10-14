{ config, lib, pkgs, ... }:
let
  inherit (pkgs) btop;
  inherit (lib) mkForce;
in {
  imports = [
    ../../images/raspberry-pi/4

    # ./hardware-configuration.nix

    ../../nixos/common
    ../../nixos/openssh-server
    ../../nixos/adguardhome
  ];

  networking = {
    hostName = "ironforge";
    useDHCP = false;
    interfaces = {
      wlan0.useDHCP = true;
      end0.useDHCP = true;
    };
  };

  environment.systemPackages = [
    btop
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

  services.adguardhome.settings = {
    dns = {
      bind_hosts = mkForce [
        "192.168.1.232"
      ];
    };
    user_rules = [
      "@@||opinionstage.com^"
      "@@||cdn.segment.com^"
      "@@||in.au1.segmentapis.com^"
    ];
  };

  hardware.pulseaudio.enable = mkForce false;
  sound.enable = mkForce false;

  system.stateVersion = "24.05";
}
