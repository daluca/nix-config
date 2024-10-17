{ lib, pkgs, system, ... }:
let
  inherit (lib) mkForce;
  inherit (pkgs) vim;
in {
  imports = [
    ../../images/raspberry-pi/4

    ../../nixos/openssh-server
  ];

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nix.settings.trusted-users = [ "@wheel" ];

  environment.systemPackages = [
    vim
  ];

  services.openssh.settings.AllowUsers = mkForce [ "daluca" ];

  users.users.root.initialPassword = "root";

  services.getty.autologinUser = "daluca";

  users.mutableUsers = true;
  users.users.daluca = {
    isNormalUser = true;
    initialPassword = "test";
    extraGroups = [ "wheel" ];
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIZuHaRedC+s+EbKgGj1ZBQ0tClxgfYt6XVd1grNUgjV daluca@artemis"
    ];
  };

  networking.hostName = "stormwind";

  hardware.raspberry-pi.config.pi4 = {
    dt-overlays.rpi-poe = {
      enable = true;
      params = {
        poe_fan_temp0 = { enable = true; value = 65 * 1000; };
        poe_fan_temp1 = { enable = true; value = 70 * 1000; };
        poe_fan_temp2 = { enable = true; value = 75 * 1000; };
        poe_fan_temp3 = { enable = true; value = 80 * 1000; };
      };
    };
  };

  nixpkgs.buildPlatform.system = "x86_64-linux";
  nixpkgs.hostPlatform.system = system;

  system.stateVersion = "24.05";
}
