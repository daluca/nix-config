{ config, system, inputs, ... }:
let
  inherit (inputs.nixvim-config.packages.${system}) neovim;
in {
  home.packages = [(
    neovim.extend {
      config.colorschemes.catppuccin.settings.flavor = config.catppuccin.flavor;
    }
  )];

  home.sessionVariables = {
    EDITOR = "nvim";
  };

  home.shellAliases = {
    n = "nvim";
    vimdiff = "nvim -d";
  };
}
