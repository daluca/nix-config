{ config, lib, secrets, outputs, ... }:

{
  imports = with outputs.nixosModules; [
    ./..
    ./disko.nix

    hetzner-online-intel
  ] ++ map (m: lib.custom.relativeToUsers m) [
    "starr"
  ] ++ map (m: lib.custom.relativeToNixosModules m) [
    "grub"
    "impermanence/grub"
    "remote-unlocking"
    "tailscale/server"
    "nginx"
    "jellyfin"
    "jellyseerr"
    "sonarr"
    "radarr"
    "prowlarr"
    "configarr"
    "sabnzbd"
    "qbittorrent"
  ];

  hardware.graphics.enable = true;

  security.acme.certs.${secrets.domain.general}.domain = "*.${secrets.domain.general}";

  services.nginx.virtualHosts = import ./routes.nix { inherit config secrets; };

  networking.hostName = "shodan";

  systemd.network.networks."10-uplink".networkConfig.Address = secrets.hosts.shodan.ipv6-address;

  host.network.interface = "enp0s31f6";

  system.stateVersion = "25.11";
}
