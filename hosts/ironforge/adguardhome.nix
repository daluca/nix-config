{ config, lib, secrets, ... }:
let
  allowDomain = domain: "@@||${domain}^";
  blockDomain = domain: "||${domain}^";
in {
  services.adguardhome = {
    port = 80;
    openFirewall = true;
    settings = {
      dns = {
        bind_hosts = [ "192.168.10.10" ];
        upstream_dns = [
          "[//168.192.in-addr.arpa/${config.networking.domain}/]192.168.10.254"
        ];
        fallback_dns = [
          "9.9.9.9"
          "149.112.112.112"
        ];
        hostsfile_enabled = false;
      };
      filtering.rewrites = [
        {
          domain = "ironforge.${config.networking.domain}";
          answer = "192.168.10.10";
        }
        {
          domain = secrets.parents.domain;
          answer = "192.168.10.20";
        }
        {
          domain = "*.${secrets.parents.domain}";
          answer = "192.168.10.20";
        }
      ];
      user_rules = map (d: allowDomain d) [
        "opinionstage.com"
      ] ++ map (d: blockDomain d) [
        "ota.onecloud.harman.com"
      ];
    };
  };
}
