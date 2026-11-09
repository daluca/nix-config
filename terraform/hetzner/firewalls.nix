{ lib, ... }:
let
  anywhere = [
    "0.0.0.0/0"
    "::/0"
  ];
  rule = protocol: port: {
    inherit protocol;
    direction = "in";
    port = toString port;
    source_ips = anywhere;
  };
  tcp = port: rule "tcp" port;
  udp = port: rule "udp" port;
  firewalls = {
    default = {
      rule = [
        {
          direction = "in";
          protocol = "icmp";
          source_ips = anywhere;
        }
        (tcp 22)
        (tcp 22022)
      ];
      id = 10079862;
    };
    http = {
      rule = [
        (tcp 80)
        (tcp 443)
      ];
      id = 2317203;
    };
    netbird = {
      rule = [
        (udp 3478)
      ];
      id = 11830494;
    };
  };
in
{
  import = lib.mapAttrsToList (name: data: {
    to = "hcloud_firewall.${name}";
    inherit (data) id;
  }) firewalls;

  resource.hcloud_firewall = lib.mapAttrs (name: data: {
    inherit name;
    inherit (data) rule;
  }) firewalls;
}
