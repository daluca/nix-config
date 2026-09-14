{ withSystem, ... }:

{
  flake.overlays.neovim =
    _final: prev:
    withSystem prev.stdenv.hostPlatform.system (
      { inputs', ... }: {
        neovim = inputs'.nixvim-config.packages.neovim;
      }
    );

  flake.homeManagerModules.neovim =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    {
      home.packages = with pkgs; [
        (neovim.extend {
          config = {
            colorschemes.catppuccin.settings.flavor = config.catppuccin.flavor;
          };
        })
      ];

      home.sessionVariables = {
        EDITOR = lib.mkForce "nvim";
      };

      home.shellAliases = {
        n = "nvim";
        vimdiff = "nvim -d";
      };

      home.persistence.home.directories = [
        ".local/share/nvim"
      ];
    };

  flake.homeManagerModules.neovide = { config, pkgs, ... }: {
    programs.neovide = {
      enable = true;
      package = pkgs.unstable.neovide;
      settings = {
        font =
          let
            font = "Monaspace Krypton Var";
          in
          {
            normal = [ font ];
            size = 12;
            features.${font} = [
              "+calt"
              "+ss01"
              "+ss02"
              "+ss03"
              "+ss04"
              "+ss05"
              "+ss06"
              "+ss07"
              "+ss08"
              "+ss09"
              "+ss10"
              "+liga"
            ];
          };
      };
    };

    xdg.mimeApps.defaultApplicationPackages = with config; [
      programs.neovide.package
    ];
  };
}
