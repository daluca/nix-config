{ lib, ... }:

{
  imports = [
    ./..
  ] ++ map (m: lib.custom.relativeToRoot m) [
    "images/raspberry-pi/4"
  ] ++ map (m: lib.custom.relativeToNixosModules m) [
    "openssh/server"
    "tailscale/server"
  ];

  services.getty.autologinUser = "daluca";

  networking.hostName = "darnassus";

  networking.localCommands = /* bash */ ''
    ip rule add to 192.168.1.0/24 priority 2500 lookup main || true
  '';

  services.tailscale.extraUpFlags = [
    "--advertise-routes=192.168.1.192/26"
    "--hostname=united-kingdom"
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

  system.stateVersion = "25.05";
}
