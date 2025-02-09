{ config, system, inputs, ... }:
let
  inherit (inputs.nixvim-config.packages.${system}) neovim;
in {
  home.packages = [(
    neovim.extend {
      config.colorschemes.catppuccin.settings.flavour = config.catppuccin.flavour;
    }
  )];

  home.sessionVariable = {
    EDITOR = "nvim";
  };

  home.shellAliases = {
    n = "nvim";
    vimdiff = "nvim -d";
  };
}
