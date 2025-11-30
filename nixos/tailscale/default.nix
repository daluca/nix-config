{ config, secrets, ... }:

{
  services.tailscale = {
    enable = true;
    openFirewall = true;
    authKeyFile = config.sops.secrets."tailscale/preauthkey".path;
    extraUpFlags = [
      "--login-server=https://headscale.${secrets.cloud.domain}"
      "--operator=${config.home-manager.users.daluca.home.username}"
      "--accept-routes"
      "--reset"
    ];
  };

  sops.secrets."tailscale/preauthkey" = {
    owner = config.home-manager.users.daluca.home.username;
  };

  networking.firewall.trustedInterfaces = [ "tailscaled0" ];
}
