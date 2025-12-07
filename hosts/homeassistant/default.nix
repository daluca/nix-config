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

  boot.loader.raspberryPi.bootloader = "kernel";

  system.stateVersion = "25.11";
}
