{ config, lib, system, inputs, ... }:
let
  inherit (inputs.nixvim-config.packages.${system}) neovim;
in {
  home.packages = [(
    neovim.extend {
      config = {
        colorschemes.catppuccin.settings.flavor = config.catppuccin.flavor;
      };
    }
  )];

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
}
