{ config, secrets, ... }:

{
  services.adguardhome = {
    port = 80;
    openFirewall = true;
    settings = {
      dns = {
        bind_hosts = [ "10.1.1.10" ];
        upstream_dns = [
          "[//in-addr.arpa/${config.networking.domain}/]10.1.1.1"
          "[//ip6.arpa/${config.networking.domain}/]10.1.1.1"
          "[/${secrets.parents.domain}/]192.168.10.10"
        ];
        fallback_dns = [
          "9.9.9.9"
          "149.112.112.112"
        ];
        hostsfile_enabled = false;
        local_ptr_upstreams = [
          "10.1.1.1"
        ];
      };
      filtering.rewrites =
      let
        dalaran = subdomain: {
          domain = "${subdomain}.${secrets.domain.general}";
          answer = "10.1.1.11";
        };
        internalHost = hostName: answer: {
          inherit answer;
          domain = "${hostName}.${config.networking.domain}";
        };
        externalHost = hostName: {
          domain = "${hostName}.${config.networking.domain}";
          answer = secrets.hosts.${hostName}.ipv4-address;
        };
      in [
        (internalHost "stormwind" "10.1.1.10")
        (internalHost "ironforge" "192.168.10.10")
        (internalHost "guiltyspark" "192.168.10.20")
        (internalHost "darnassus" "192.168.1.212")
        (externalHost "alfa")
        (externalHost "bravo")
        (externalHost "charlie")
        (externalHost "delta")
        (externalHost "unifi")
        (externalHost "shodan")
        (dalaran "paperless")
        (dalaran "redlib")
        (dalaran "adguardhome")
        (dalaran "navidrome")
        (dalaran "firefly")
        (dalaran "firefly-importer")
        (dalaran "home-assistant")
        (dalaran "zigbee2mqtt")
        (dalaran "unifi")
      ];
    };
  };
}
