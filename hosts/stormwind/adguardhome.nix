{ config, ... }:
let
  hostIPAddress = "10.0.0.10";
in {
  services.adguardhome.settings = {
    dns = {
      bind_hosts = [ hostIPAddress ];
      upstream_dns = [
        "[/10.in-addr.arpa/]10.0.0.1"
        "[/internal/]10.0.0.1"
      ];
    };
    filtering = {
      rewrites = [{
        domain = "${config.networking.hostName}.internal";
        answer = hostIPAddress;
      }];
    };
  };
}
