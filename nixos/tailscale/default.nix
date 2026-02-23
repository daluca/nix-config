{ config, lib, pkgs, secrets, ... }:

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

  networking.firewall.trustedInterfaces = [
    "tailscale0"
  ];

  systemd.services.tailscaled.serviceConfig.Environment = [
    "TS_DEBUG_FIREWALL_MODE=nftables"
  ];

  services.networkd-dispatcher.enable = true;

  services.networkd-dispatcher = {
    rules."50-tailscale-optimizations" = {
      onState = [ "routable" ];
      script = /* bash */ ''
        ${lib.getExe pkgs.ethtool} --features ${config.host.network.interface} rx-udp-gro-forwarding on rx-gro-list off
      '';
    };
  };
}
