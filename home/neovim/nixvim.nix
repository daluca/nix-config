{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
let
  retrail-nvim = pkgs.unstable.vimUtils.buildVimPlugin {
    name = "retrail.nvim";
    src = pkgs.unstable.fetchFromGitHub {
      owner = "kaplanz";
      repo = "retrail.nvim";
      rev = "v0.1.8";
      hash = "sha256-IaQFEaq9cxSRllUjD0rcV3zTwix54kgsVyB8XbtCQdU=";
    };
  };
in
{
  imports = [ inputs.nixvim.homeManagerModules.nixvim ];

  programs.nixvim = {
    enable = true;
    vimAlias = true;
    defaultEditor = true;
    globals = {
      mapleader = " ";
    };
    opts = {
      number = true;
      relativenumber = true;
      scrolloff = 8;
      expandtab = true;
      tabstop = 2;
      softtabstop = 2;
      shiftwidth = 2;
      cursorline = true;
      signcolumn = "yes";
    };
    colorschemes.catppuccin = {
      enable = true;
      settings.flavour = "mocha";
    };
    plugins = {
      gitsigns.enable = true;
      lazy = {
        enable = true;
        plugins = with pkgs.unstable.vimPlugins; [
          gitsigns-nvim
          lualine-nvim
          nvim-tree-lua
          retrail-nvim
          telescope-nvim
          toggleterm-nvim
          which-key-nvim
        ];
      };
      lualine = {
        enable = true;
        theme = "catppuccin";
      };
      nvim-tree.enable = true;
      telescope = {
        enable = true;
        keymaps = {
          "<leader>ff" = {
            action = "find_files";
            options = {
              desc = "[f]ind [f]iles";
            };
          };
          "<leader>fg" = {
            action = "live_grep";
            options = {
              desc = "[f]ind with [g]rep";
            };
          };
          "<leader>fk" = {
            action = "keymaps";
            options = {
              desc = "[f]ind [k]eymaps";
            };
          };
        };
      };
      toggleterm = {
        enable = true;
        settings = {
          direction = "float";
        };
      };
      which-key.enable = true;
    };
    extraPlugins = [ retrail-nvim ];
    extraConfigLua = ''
      require('retrail').setup()
    '';
  };

  home.packages =
    with pkgs.unstable;
    lib.mkIf config.programs.nixvim.plugins.telescope.enable [
      fd
      ripgrep
    ];
}
