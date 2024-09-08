{ pkgs, ... }:

{
  services.tailscale = {
    enable = true;
    package = pkgs.unstable.tailscale;
    openFirewall = true;
    useRoutingFeatures = "both";
  };
}
