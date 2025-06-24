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

  nix.settings.trusted-users = [ "@wheel" ];

  services.getty.autologinUser = "daluca";

  networking = {
    hostName = "stormwind";
    useDHCP = false;
    interfaces.end0 = {
      ipv4.addresses = [
        {
          address = "192.168.178.10";
          prefixLength = 24;
        }
      ];
    };
    defaultGateway = {
      address = "192.168.178.1";
      interface = "end0";
    };
  };

  networking.localCommands = /* bash */ ''
    ip rule add to 192.168.178.0/24 priority 2500 lookup main || true
  '';

  sops.secrets."ssh_host_ed25519_key".sopsFile = ./stormwind.sops.yaml;

  sops.secrets."ssh_host_rsa_key".sopsFile = ./stormwind.sops.yaml;

  sops.secrets."tailscale/preauthkey".sopsFile = ./stormwind.sops.yaml;

  services.tailscale.extraUpFlags = [
    "--advertise-routes=192.168.178.0/24"
    "--hostname=waalsdorperweg"
  ];

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

  system.stateVersion = "25.05";
}
