{ config, lib, pkgs, system, ... }:
let
  inherit (lib) mkForce;
  inherit (pkgs) vim;
in {
  imports = [
    ../../images/raspberry-pi/4

    ../../nixos/common
    ../../nixos/openssh/server
    ../../nixos/tailscale/server
    ../../nixos/adguardhome

    ./adguardhome.nix
  ];

  nix.settings.trusted-users = [ "@wheel" ];

  services.getty.autologinUser = "daluca";

  environment.systemPackages = [
    vim
  ];

  networking.hostName = "ironforge";

  sops.secrets."tailscale/preauthkey" = {
    sopsFile = ./ironforge.sops.yaml;
  };

  services.tailscale.extraUpFlags = [
    "--advertise-routes=192.168.1.0/24"
    "--hostname=idris"
  ];

  hardware.raspberry-pi.config.pi4 = {
    dt-overlays.gpio-fan = {
      enable = true;
      params = {
        gpiopin = { enable = true; value = 14; };
        temp = { enable = true; value = 80 * 1000; };
        hyst = { enable = true; value = 10 * 1000; };
      };
    };
  };

  system.stateVersion = "24.11";
}
