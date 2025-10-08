{ config, lib, secrets, ... }:
let
  hours = 60 * 60;
in {
  services.adguardhome = {
    port = 80;
    openFirewall = true;
    settings = {
      dns = {
        bind_hosts = [ "192.168.178.10" ];
        upstream_dns = [
          "[//178.168.192.in-addr.arpa/${config.networking.domain}/]192.168.178.1"
          "[/${secrets.parents.domain}/]192.168.10.10"
        ];
        fallback_dns = [
          "9.9.9.9"
          "149.112.112.112"
        ];
        hostsfile_enabled = false;
      };
      filtering.rewrites = [
        {
          domain = "stormwind.${config.networking.domain}";
          answer = "192.168.178.10";
        }
        {
          domain = "ironforge.${config.networking.domain}";
          answer = "192.168.10.10";
        }
        {
          domain = "guiltyspark.${config.networking.domain}";
          answer = "192.168.10.20";
        }
        {
          domain = "darnassus.${config.networking.domain}";
          answer = "192.168.1.212";
        }
        {
          domain = "alfa.${config.networking.domain}";
          answer = secrets.hosts.alfa.ipv4-address;
        }
        {
          domain = "bravo.${config.networking.domain}";
          answer = secrets.hosts.bravo.ipv4-address;
        }
        {
          domain = "unifi.${config.networking.domain}";
          answer = secrets.hosts.unifi.ipv4-address;
        }
      ];
      dhcp = {
        enabled = true;
        interface_name = "end0";
        local_domain_name = config.networking.domain;
        dhcpv4 = {
          gateway_ip = "192.168.178.1";
          subnet_mask = "255.255.255.0";
          range_start = "192.168.178.100";
          range_end = "192.168.178.200";
          lease_duration = 24 * hours;
          options = [
            "6 ips 192.168.178.10,192.168.178.11"
            # TODO: Remove when issue has been fixed
            # https://github.com/AdguardTeam/AdGuardHome/issues/6749
            # Work around: Manually supply option
            "15 text ${config.networking.domain}"
          ];
        };
      };
    };
  };

  networking.firewall = rec {
    allowedTCPPorts = [ 67 ];
    allowedUDPPorts = allowedTCPPorts;
  };
}
