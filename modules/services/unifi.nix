{
  flake.nixosModules.unifi-controller = { lib, pkgs, ... }: {
    services.unifi = {
      enable = true;
      mongodbPackage = pkgs.mongodb-7_0;
      openFirewall = true;
    };

    systemd.services.unifi = {
      environment.LD_LIBRARY_PATH = lib.mkForce "${pkgs.stdenv.cc.cc.lib}/lib:${pkgs.systemdLibs}/lib";
    };
  };
}
