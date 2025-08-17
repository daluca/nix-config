{ config, secrets, ... }:

{
  services.adguardhome = {
    allowDHCP = true;
    settings = {
      dns = {
        bind_hosts = [ "192.168.178.10" ];
        upstream_dns = [
          "[//178.168.192.in-addr.arpa/${config.networking.domain}/]192.168.178.1"
          "[/guiltyspark.${config.networking.domain}/ironforge.${config.networking.domain}/]192.168.1.1"
          "[/${secrets.parents.domain}/]192.168.1.10"
        ];
        fallback_dns = [
          "192.168.1.10"
        ];
        hostsfile_enabled = false;
      };
      dhcp = {
        enabled = true;
        interface_name = "end0";
        local_domain_name = config.networking.domain;
        dhcpv4 = {
          gateway_ip = "192.168.178.1";
          subnet_mask = "255.255.255.0";
          range_start = "192.168.178.100";
          range_end = "192.168.178.200";
          lease_duration = 60 * 60 * 24;
          options = [
            "6 ips 192.168.178.10,${secrets.hosts.alpha.ipv4-address}"
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
