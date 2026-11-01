{
  flake.homeModules.fd = { pkgs, ... }: {
    programs.fd = {
      enable = true;
      package = pkgs.unstable.fd;
    };
  };
}
