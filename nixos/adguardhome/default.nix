{ config, pkgs, secrets, ... }:
let
  inherit (pkgs.unstable) adguardhome;
in {
  imports = [
    ../unbound
  ];

  services.adguardhome = {
    enable = true;
    package = adguardhome;
    mutableSettings = false;
    openFirewall = true;
    port = 80;
    settings = {
      users = [{
        name = config.home-manager.users.daluca.home.username;
        password = secrets.adguardhome.password;
      }];
      dns = {
        bind_hosts = [
          "127.0.0.1"
        ];
        upstream_dns = [
          "127.0.0.1:5353"
        ];
        bootstrap_dns = [
          "9.9.9.9"
          "149.112.112.112"
        ];
      };
      filters = [{
        enabled = true;
        url = "https://big.oisd.nl/";
        name = "oisd big";
        id = 1;
      }];
    };
  };

  networking.firewall = rec {
    allowedTCPPorts = [ 53 ];
    allowedUDPPorts = allowedTCPPorts;
  };
}
