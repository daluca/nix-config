{
  flake.homeManagerModules.yazi = {
    programs.yazi = {
      enable = true;
    };

    catppuccin.yazi.enable = true;
  };
}
