{
  flake.homeManagerModules.fd = { pkgs, ... }: {
    programs.fd = {
      enable = true;
      package = pkgs.unstable.fd;
    };
  };
}
