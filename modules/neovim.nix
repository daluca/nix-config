{ inputs, ... }:

{
  flake.overlays.neovim = final: _prev: {
    neovim = inputs.nixvim-config.packages.${final.stdenv.hostPlatform.system}.neovim;
  };

  flake.homeManagerModules.neovim = { config, lib, pkgs, ... }: {
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
}
