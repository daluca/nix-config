{ config, secrets, ... }:

{
  services.adguardhome = {
    allowDHCP = true;
    settings = {
      dns = {
        bind_hosts = [ "192.168.178.10" ];
        upstream_dns = [
          "[//178.168.192.in-addr.arpa/${config.networking.domain}/]192.168.178.1"
          "[/ironforge.${config.networking.domain}/]192.168.1.1"
          "[/${secrets.parents.domain}/]192.168.1.10"
        ];
        fallback_dns = [
          "192.168.1.10"
        ];
        hostsfile_enabled = false;
        local_domain_name = config.networking.domain;
      };
      dhcp = {
        enabled = true;
        interface_name = "end0";
        dhcpv4 = {
          gateway_ip = "192.168.178.1";
          subnet_mask = "255.255.255.0";
          range_start = "192.168.178.100";
          range_end = "192.168.178.200";
          lease_duration = 60 * 60 * 24;
        };
      };
    };
  };

  networking.firewall = rec {
    allowedTCPPorts = [ 67 ];
    allowedUDPPorts = allowedTCPPorts;
  };
}
