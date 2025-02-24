{ config, ... }:
let
  inherit (config.networking) domain;
in {
  services.adguardhome.settings = {
    dns = {
      bind_hosts = [ "10.0.0.10" ];
      upstream_dns = [
        "[//10.in-addr.arpa/${domain}/]10.0.0.1"
        "[/ironforge.${domain}/]192.168.1.1"
      ];
      hostsfile_enabled = false;
    };
  };
}
