{
  flake.homeModules.btop = { pkgs, ... }: {
    programs.btop = {
      enable = true;
      package = pkgs.unstable.btop;
    };

    catppuccin.btop.enable = true;
  };
}
