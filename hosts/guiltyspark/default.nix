{ config, lib, pkgs, secrets, inputs, ... }:

{
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
    "jellyfin"
    "sonarr"
    "radarr"
    "prowlarr"
    "sabnzbd"
    "qbittorrent"
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

  system.stateVersion = "24.11";
}
