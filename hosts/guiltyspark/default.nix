{ config, lib, pkgs, inputs, ... }@args:
let
  secrets = args.secrets // builtins.fromTOML (builtins.readFile ./secrets.toml);
in {
  imports = [
    inputs.nixos-hardware.nixosModules.common-cpu-intel
    inputs.disko.nixosModules.disko

    ./disko.nix
  ] ++ map (m: lib.custom.relativeToHosts m) [
    "."
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
    "nginx"
  ] ++ map (m: lib.custom.relativeToUsers m) [
    "remotebuild"
    "starr"
  ];

  networking = {
    hostName = "guiltyspark";
    hostId = "5c9bd4a2";
  };

  sops.secrets."ssh_host_ed25519_key".sopsFile = ./guiltyspark.sops.yaml;

  sops.secrets."ssh_host_rsa_key".sopsFile = ./guiltyspark.sops.yaml;

  sops.secrets."tailscale/preauthkey".sopsFile = ./guiltyspark.sops.yaml;

  services.tailscale.extraUpFlags = [
    "--advertise-routes=192.168.1.0/24"
  ];

  networking.localCommands = /* bash */ ''
    ip rule add to 192.168.1.0/24 priority 2500 lookup main || true
  '';

  security.acme.certs.${secrets.parents.domain} = {
    domain = "*.${secrets.parents.domain}";
    group = "nginx";
    dnsProvider = "cloudflare";
    environmentFile = "${pkgs.writeText "cloudflare-credentials" ''
      CLOUDFLARE_DNS_API_TOKEN_FILE=${config.sops.secrets."cloudflare/apitoken".path}
    ''}";
  };

  sops.secrets."cloudflare/apitoken" = {
    owner = "acme";
    sopsFile = ./guiltyspark.sops.yaml;
  };

  services.jellyplex-watched = {
    mappings.users = secrets.jellyplex-watched.users;
    plex.tokens = [ secrets.plex.token ];
    jellyfin.tokens = [ secrets.jellyfin.token ];
  };

  system.stateVersion = "25.05";
}
