{
  flake.nixosModules.plex = { pkgs, ... }: {
    services.plex = {
      enable = true;
      package = pkgs.unstable.plex;
      openFirewall = true;
    };
  };
}
