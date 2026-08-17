{
  flake.homeManagerModules.lazygit = { config, lib, pkgs, ... }: {
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
      lazy = "!${lib.getExe config.programs.lazygit.package}";
    };

    programs.yazi.plugins = { inherit (pkgs.yaziPlugins) lazygit; };

    programs.yazi.keymap = {
      mgr.prepend_keymap = [
        {
          on = [ "g" "i" ];
          run = "plugin lazygit";
          desc = "run lazygit";
        }
      ];
    };
  };
}
