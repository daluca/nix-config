{ lib, ... }:

{
  imports = [
    ./..
  ] ++ map (m: lib.custom.relativeToRoot m) [
    "images/digitalocean"
  ] ++ map (m: lib.custom.relativeToNixosModules m) [
    "openssh/server"
    "unifi-controller"
  ];

  networking.hostName = "unifi";
  networking.enableIPv6 = false;

  system.stateVersion = "25.05";
}
