{ config, lib, pkgs, inputs, ... }:

{
  imports = [
    inputs.nixvim.homeManagerModules.nixvim
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
      telescope.enable = true;
      telescope.keymaps = {
        "<leader>ff".action = "find_files";
	      "<leader>fg".action = "live_grep";
	      "<leader>fk".action = "keymaps";
      };
      toggleterm.enable = true;
      toggleterm.settings.direction = "float";
      treesitter.enable = true;
      which-key.enable = true;
    };
  };

  home.packages = with pkgs.unstable; lib.mkIf config.programs.nixvim.plugins.telescope.enable [
    fd
    ripgrep
  ];
}
