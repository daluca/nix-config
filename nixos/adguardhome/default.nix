{ config, lib, pkgs, ... }:

{
  services.adguardhome = {
    enable = true;
    mutableSettings = false;
    settings = {
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
      filters = [
        {
          enabled = true;
          url = "https://big.oisd.nl/";
          name = "oisd big";
          id = 1;
        }
      ];
    };
  };

  services.unbound = {
    enable = true;
    package = pkgs.unbound-full;
    resolveLocalQueries = false;
    settings = {
      server = {
        interface = [ "127.0.0.1@5353" ];
        verbosity = 2;
        module-config = "\"${lib.concatStringsSep " " [
          "validator"
          "cachedb"
          "iterator"
        ]}\"";
      };
      remote-control.control-enable = true;
      cachedb = {
        backend = "redis";
        redis-server-path = config.services.redis.servers.unbound.unixSocket;
      };
   };
  };

  services.redis.servers.unbound = with config.services; {
    enable = true;
    user = unbound.user;
    group = unbound.group;
  };

  networking.firewall = {
    allowedUDPPorts = [ 53 ];
  };

  environment.persistence.system.directories = [
    { directory = "/var/lib/private/AdGuardHome"; mode = "0700"; }
  ];
}
