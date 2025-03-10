{ lib, pkgs, ... }:
let
  inherit (pkgs) unifi8 mongodb-7_0;
in {
  services.unifi = {
    enable = true;
    unifiPackage = unifi8.overrideAttrs (oldAttrs: rec {
      version = "8.6.9";

      src = pkgs.fetchurl {
        url = "https://dl.ubnt.com/unifi/${version}/unifi_sysvinit_all.deb";
        sha256 = "sha256-004ZJEoj23FyFEBznqrpPzQ9E6DYpD7gBxa3ewSunIo=";
      };
    });
    mongodbPackage = mongodb-7_0;
    openFirewall = true;
  };

  systemd.services.unifi = {
    environment.LD_LIBRARY_PATH = lib.mkForce "${pkgs.stdenv.cc.cc.lib}/lib:${pkgs.systemdLibs}/lib";
  };

  networking.firewall.allowedTCPPorts = [
    8443
  ];
}
