{ config, pkgs, ... }:
let
  inherit (pkgs.unstable) cachix;
in {
  services.cachix-watch-store = {
    enable = true;
    package = cachix;
    cacheName = "daluca";
    cachixTokenFile = config.sops.secrets."cachix/token".path;
  };

  sops.secrets."cachix/token" = { };
}
