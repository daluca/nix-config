{ config, lib, pkgs, ... }:

{
  services.tailscale = {
    enable = true;
    package = pkgs.unstable.tailscale;
    openFirewall = true;
    useRoutingFeatures = "both";
    extraSetFlags = [
      "--accept-routes"
      "--advertise-exit-node"
      "--advertise-routes=10.0.0.0/14"
    ];
  };

  environment.persistence.system.directories = lib.mkIf config.environment.persistence.system.enable [
    { directory = "/var/lib/tailscale"; mode = "0700"; }
  ];
}
