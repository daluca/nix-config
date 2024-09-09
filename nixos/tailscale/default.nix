{ config, lib, pkgs, secrets, ... }:

{
  services.tailscale = {
    enable = true;
    package = pkgs.unstable.tailscale;
    openFirewall = true;
    useRoutingFeatures = "both";
    authKeyFile = config.sops.secrets.tailscale-preauthkey.path;
    extraUpFlags = [
      "--login-server=http://headscale.${secrets.cloud.domain}"
      "--operator=${config.home-manager.users.daluca.home.username}"
      "--accept-routes"
      "--advertise-exit-node"
      "--advertise-routes=10.0.0.0/14"
      "--hostname=${config.networking.hostName}"
      "--reset"
    ];
  };

  sops.secrets.tailscale-preauthkey = { };

  environment.persistence.system.directories = lib.mkIf config.environment.persistence.system.enable [
    { directory = "/var/lib/tailscale"; mode = "0700"; }
  ];
}
