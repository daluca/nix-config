{ pkgs, ... }:

rec {
  programs.lazygit = {
    enable = true;
    package = pkgs.unstable.lazygit;
    settings = {
      disableStartupPopups = true;
      confirmOnQuit = true;
      gui.useHunkModeInStagingView = true;
    };
  };

  catppuccin.lazygit.enable = true;

  programs.git.settings.alias = {
    lazy = "!${programs.lazygit.package}/bin/lazygit";
  };
}
