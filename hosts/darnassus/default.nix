{ pkgs, ... }:
let
  inherit (pkgs) vim;
in {
  imports = [
    ../../images/raspberry-pi/4

    ../../nixos/common
    ../../nixos/openssh/server
  ];

  services.getty.autologinUser = "daluca";

  environment.systemPackages = [
    vim
  ];

  networking.hostName = "darnassus";

  sops.secrets."ssh_host_ed25519_key".sopsFile = ./darnassus.sops.yaml;

  sops.secrets."ssh_host_rsa_key".sopsFile = ./darnassus.sops.yaml;

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
