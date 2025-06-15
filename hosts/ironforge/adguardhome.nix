{ config, secrets, ... }:
let
  allowDomain = domain: "@@||${domain}^";
  blockDomain = domain: "||${domain}^";
in {
  services.adguardhome.settings = {
    dns = {
      bind_hosts = [ "192.168.1.10" ];
      upstream_dns = [
        "192.168.178.10"
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
    ] ++ map (d: blockDomain d) [
      "ota.onecloud.harman.com"
    ];
  };
}
