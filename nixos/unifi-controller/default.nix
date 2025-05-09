{ lib, pkgs, ... }:
let
  inherit (pkgs) unifi mongodb-7_0;
in {
  services.unifi = {
    enable = true;
    # TODO: Remove package override in NixOS 25.05
    unifiPackage = unifi.overrideAttrs (oldAttrs: rec {
      version = "9.0.114";

      src = pkgs.fetchurl {
        url = "https://dl.ubnt.com/unifi/${version}/unifi_sysvinit_all.deb";
        sha256 = "sha256-3xumIIzr+tx60kPhPfSs2Kz2iJ39Kt5934Vca/MpUu4=";
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
