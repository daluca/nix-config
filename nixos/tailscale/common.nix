{ config, pkgs, secrets, ... }:
let
  inherit (config.home-manager.users) daluca;
in {
  services.tailscale = {
    enable = true;
    package = pkgs.unstable.tailscale;
    openFirewall = true;
    authKeyFile = config.sops.secrets."tailscale/preauthkey".path;
    extraUpFlags = [
      "--login-server=https://headscale.${secrets.cloud.domain}"
      "--operator=${daluca.home.username}"
      "--accept-routes"
      "--reset"
    ];
  };

  sops.secrets."tailscale/preauthkey" = {
    owner = daluca.home.username;
  };

  networking.firewall.trustedInterfaces = [ "tailscaled0" ];
}
