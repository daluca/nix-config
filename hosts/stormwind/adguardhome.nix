{ config, ... }:
let
  inherit (config.networking) domain;
in {
  services.adguardhome.settings = {
    dns = {
      bind_hosts = [ "192.168.178.10" ];
      upstream_dns = [
        "192.168.1.10"
        "[//178.168.192.in-addr.arpa/${domain}/]192.168.178.1"
        "[/ironforge.${domain}/]192.168.1.1"
      ];
      hostsfile_enabled = false;
    };
  };
}
