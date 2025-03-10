{ lib, ... }:

{
  imports = map (m: lib.custom.relativeToRoot m) [
    "images/raspberry-pi/4"
  ] ++ map (m: lib.custom.relativeToHosts m) [
    "."
  ] ++ map (m: lib.custom.relativeToNixosModules m) [
    "openssh/server"
  ] ++ map (m: lib.custom.relativeToUsers m) [
    "remotebuild"
  ];

  services.getty.autologinUser = "daluca";

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
