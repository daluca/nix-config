{ lib, pkgs, ... }:

{
  services.unifi = {
    enable = true;
    mongodbPackage = pkgs.mongodb-ce;
    openFirewall = true;
  };

  systemd.services.unifi = {
    environment.LD_LIBRARY_PATH = lib.mkForce "${pkgs.stdenv.cc.cc.lib}/lib:${pkgs.systemdLibs}/lib";
  };

  nixpkgs.config.permittedInsecurePackages = [
    "unifi-controller-9.5.21"
  ];
}
