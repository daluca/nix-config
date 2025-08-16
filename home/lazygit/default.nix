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

  programs.git.aliases = {
    lazy = "!${programs.lazygit.package}/bin/lazygit";
  };
}
