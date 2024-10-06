{ config, lib, pkgs, secrets, ... }:

{
  services.tailscale = {
    enable = true;
    package = pkgs.unstable.tailscale;
    openFirewall = true;
    useRoutingFeatures = "client";
    authKeyFile = config.sops.secrets.tailscale-preauthkey.path;
    extraUpFlags = [
      "--login-server=https://headscale.${secrets.cloud.domain}"
      "--operator=${config.home-manager.users.daluca.home.username}"
      "--accept-routes"
      "--accept-dns"
      "--shields-up"
      "--hostname=${config.networking.hostName}"
      "--reset"
    ];
  };

  sops.secrets.tailscale-preauthkey = { };

  environment.persistence.system.directories = lib.mkIf config.environment.persistence.system.enable [
    { directory = "/var/lib/tailscale"; mode = "0700"; }
  ];
}
