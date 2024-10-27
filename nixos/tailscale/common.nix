{ config, pkgs, secrets, ... }:
let
  inherit (pkgs.unstable) tailscale;
  inherit (config.home-manager.users) daluca;
in {
  services.tailscale = {
    enable = true;
    package = tailscale;
    openFirewall = true;
    authKeyFile = config.sops.secrets."tailscale/preauthkey".path;
    extraUpFlags = [
      "--login-server=https://headscale.${secrets.cloud.domain}"
      "--operator=${daluca.home.username}"
      "--accept-routes"
      "--accept-dns"
      "--reset"
    ];
  };

  sops.secrets."tailscale/preauthkey" = {
    owner = daluca.home.username;
  };
}
