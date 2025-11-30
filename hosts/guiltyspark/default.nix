{ config, lib, inputs, ... }@args:
let
  secrets = args.secrets // builtins.fromTOML (builtins.readFile ./secrets.toml);
in {
  imports = with inputs; [
    nixos-hardware.nixosModules.common-cpu-intel
    disko.nixosModules.disko
  ] ++ [
    ./..
    ./disko.nix
  ] ++ map (m: lib.custom.relativeToNixosModules m) [
    "grub"
    "openssh/server"
    "tailscale/server"
    "cockpit"
    "jellyfin"
    "plex"
    "sonarr"
    "radarr"
    "prowlarr"
    "sabnzbd"
    "qbittorrent"
    "jellyseerr"
    "jellyplex-watched"
    "tunarr"
    "nginx"
  ] ++ map (m: lib.custom.relativeToUsers m) [
    "remotebuild"
    "starr"
  ];

  networking = {
    hostName = "guiltyspark";
    hostId = "5c9bd4a2";
  };

  services.tailscale.extraUpFlags = [
    "--advertise-routes=192.168.10.0/24"
  ];

  networking.localCommands = /* bash */ ''
    ip rule add to 192.168.10.0/24 priority 2500 lookup main || true
  '';

  security.acme.certs.${secrets.parents.domain}.domain = "*.${secrets.parents.domain}";

  services.nginx.virtualHosts = import ./routes.nix { inherit config secrets; };

  services.cloudflare-dyndns = {
    enable = true;
    proxied = true;
    apiTokenFile = config.sops.secrets."cloudflare/api-token".path;
    domains = [
      secrets.parents.domain
    ];
  };

  services.jellyplex-watched = {
    mappings.users = secrets.jellyplex-watched.users;
    plex.tokens = [ secrets.plex.token ];
    jellyfin.tokens = [ secrets.jellyfin.token ];
  };

  system.stateVersion = "25.11";
}
