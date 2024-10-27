{ pkgs, inputs, ... }:

{
  imports = [
    inputs.nixvim.homeManagerModules.nixvim

    ./plugins
  ];

  programs.nixvim = rec {
    enable = true;
    package = pkgs.unstable.neovim-unwrapped;
    vimAlias = true;
    defaultEditor = true;
    globals.mapleader = " ";
    colorschemes.catppuccin.enable = true;
    colorschemes.catppuccin.settings.flavour = "mocha";
    opts = {
      number = true;
      relativenumber = true;
      scrolloff = 8;
      expandtab = true;
      tabstop = 2;
      softtabstop = opts.tabstop;
      shiftwidth = opts.tabstop;
      cursorline = true;
      signcolumn = "yes";
    };
    plugins = {
      fugitive.enable = true;
      gitsigns.enable = true;
      lazygit.enable = true;
      lualine.enable = true;
      toggleterm.enable = true;
      toggleterm.settings.direction = "float";
      which-key.enable = true;
    };
  };
}
