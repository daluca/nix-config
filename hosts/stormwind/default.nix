{ lib, ... }:

{
  imports = [
    ./..
    ./adguardhome.nix
  ] ++ map (m: lib.custom.relativeToRoot m) [
    "images/raspberry-pi/4"
  ] ++ map (m: lib.custom.relativeToNixosModules m) [
    "openssh/server"
    "tailscale/server"
    "adguardhome"
  ];

  services.getty.autologinUser = "daluca";



  networking.localCommands = /* bash */ ''
    ip rule add to 10.1.0.0/16 priority 2500 lookup main || true
  '';

  services.tailscale.extraUpFlags = [
    "--advertise-routes=10.1.0.0/16"
    "--hostname=the-netherlands"
  ];

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

  system.stateVersion = "25.11";
}
