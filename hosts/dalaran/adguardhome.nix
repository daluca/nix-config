{ config, lib, ... }:

{
  imports = map (m: lib.custom.relativeToHosts m) [
    "stormwind/adguardhome.nix"
  ];

  services.adguardhome.settings = {
    dhcp.enabled = lib.mkForce false;
    dns = {
      bind_hosts = lib.mkForce [
        "192.168.178.11"
        "127.0.0.1"
      ];
    };
    filtering.rewrites = [
      {
        domain = "dalaran.${config.networking.domain}";
        answer = "192.168.178.11";
      }
    ];
  };
}
