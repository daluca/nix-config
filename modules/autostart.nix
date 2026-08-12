{
  flake.homeManagerModules.autostart = {
    xdg.autostart = {
      enable = true;
      readOnly = true;
    };
  };
}
