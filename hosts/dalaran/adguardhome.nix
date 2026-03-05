{ config, lib, ... }:

{
  imports = map (m: lib.custom.relativeToHosts m) [
    "stormwind/adguardhome.nix"
  ];

  services.adguardhome = {
    port = lib.mkForce 3000;
    openFirewall = lib.mkForce true;
    settings = {
      dhcp.enabled = lib.mkForce false;
      dns = {
        bind_hosts = lib.mkForce [
          "10.1.1.11"
          "127.0.0.1"
        ];
      };
      filtering.rewrites = [
        {
          domain = "dalaran.${config.networking.domain}";
          answer = "10.1.1.11";
        }
      ];
    };
  };
}
