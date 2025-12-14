{ lib, nixos-raspberrypi, ... }:

{
  imports = [
    nixos-raspberrypi.nixosModules.sd-image
  ] ++ [
    ./..
  ] ++ map (m: lib.custom.relativeToRoot m) [
    "images/raspberry-pi/5"
  ] ++ map (m: lib.custom.relativeToNixosModules m) [
    "openssh/server"
    "home-assistant"
  ];

  networking.hostName = "homeassistant";

  system.stateVersion = "25.11";
}
