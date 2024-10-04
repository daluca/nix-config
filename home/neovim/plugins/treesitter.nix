{ pkgs, ... }:
let
  inherit (pkgs.unstable.vimPlugins) nvim-treesitter;
  treesitter-nu-grammar = pkgs.tree-sitter.buildGrammar {
    language = "nu";
    version = "0.0.0+rev=47f8fb7";
    src = pkgs.fetchFromGitHub {
      owner = "nushell";
      repo = "tree-sitter-nu";
      rev = "47f8fb740e63c5cf15ea35fee3af6c241c47f696";
      hash = "sha256-rpKsFXxWYxH/bWbFJIPP0cxVjtS8UyxsuPtYVhxJYgU=";
    };
    meta.homepage = "https://github.com/nushell/tree-sitter-nu";
  };
in {
  programs.nixvim = {
    plugins.treesitter = {
      enable = true;
      package = nvim-treesitter;
      grammarPackages = pkgs.unstable.vimPlugins.nvim-treesitter.passthru.allGrammars ++ [
        treesitter-nu-grammar
      ];
      settings.highlight.enable = true;
    };
    extraConfigLua = /* lua */ ''
      do
        local parser_config = require("nvim-treesitter.parsers").get_parser_configs()
        -- change the following as needed
        parser_config.nu = {
          install_info = {
            url = "${treesitter-nu-grammar}", -- local path or git repo
            files = {"src/parser.c"}, -- note that some parsers also require src/scanner.c or src/scanner.cc
            -- optional entries:
            --  branch = "main", -- default branch in case of git repo if different from master
            -- generate_requires_npm = false, -- if stand-alone parser without npm dependencies
            -- requires_generate_from_grammar = false, -- if folder contains pre-generated src/parser.c
          },
          filetype = "nu", -- if filetype does not match the parser name
        }
      end
    '';
    extraPlugins = [
      treesitter-nu-grammar
    ];
  };
}
