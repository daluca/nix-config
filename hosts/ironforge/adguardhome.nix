{ config, ... }:
let
  inherit (config.networking) domain;
  allowDomain = domain: "@@||${domain}^";
in {
  services.adguardhome.settings = {
    dns = {
      bind_hosts = [ "192.168.1.232" ];
      upstream_dns = [
        "[//168.192.in-addr.arpa/${domain}/]192.168.1.1"
      ];
      hostsfile_enabled = false;
    };
    user_rules = map (d: allowDomain d) [
      "opinionstage.com"
    ];
  };
}
