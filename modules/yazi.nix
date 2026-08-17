{
  flake.homeManagerModules.yazi = {
    programs.yazi = {
      enable = true;
      settings = {
        mgr.show_hidden = true;
      };
    };

    catppuccin.yazi.enable = true;
  };
}
