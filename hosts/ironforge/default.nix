{ lib, ... }:

{
  imports = [
    ./adguardhome.nix
  ] ++ map (m: lib.custom.relativeToRoot m) [
    "images/raspberry-pi/4"
  ] ++ map (m: lib.custom.relativeToHosts m) [
    "."
  ] ++ map (m: lib.custom.relativeToNixosModules m) [
    "openssh/server"
    "tailscale/server"
    "adguardhome"
  ];

  services.getty.autologinUser = "daluca";

  networking.hostName = "ironforge";

  sops.secrets."ssh_host_ed25519_key".sopsFile = ./ironforge.sops.yaml;

  sops.secrets."ssh_host_rsa_key".sopsFile = ./ironforge.sops.yaml;

  sops.secrets."tailscale/preauthkey".sopsFile = ./ironforge.sops.yaml;

  services.tailscale.extraUpFlags = [
    "--advertise-routes=192.168.10.0/24"
    "--hostname=new-zealand"
  ];

  networking.localCommands = /* bash */ ''
    ip rule add to 192.168.10.0/24 priority 2500 lookup main || true
  '';

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

  system.stateVersion = "25.05";
}
