{ config, secrets, ... }:
let
  allowDomain = domain: "@@||${domain}^";
in {
  services.adguardhome.settings = {
    dns = {
      bind_hosts = [ "192.168.1.10" ];
      upstream_dns = [
        "[//168.192.in-addr.arpa/${config.networking.domain}/]192.168.1.1"
      ];
      hostsfile_enabled = false;
    };
    filtering = {
      rewrites = [{
        domain = "*.${secrets.parents.domain}";
        answer = "192.168.1.21";
      }];
    };
    user_rules = map (d: allowDomain d) [
      "opinionstage.com"
    ];
  };
}
