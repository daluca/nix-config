{ config, pkgs, ... }:
let
  inherit (pkgs) fetchFromGitHub;
in {
  programs.zsh = rec {
    enable = true;
    dotDir = ".config/zsh";
    history = {
      save = 50000;
      size = history.save;
      path = "${config.home.homeDirectory}/${dotDir}/.zsh_history";
      share = true;
      extended = true;
      ignoreSpace = true;
      ignoreAllDups = true;
      expireDuplicatesFirst = true;
    };
    historySubstringSearch.enable = true;
    autocd = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    plugins = [
      {
        name = "zsh-nix-shell";
        file = "nix-shell.plugin.zsh";
        src = fetchFromGitHub {
          owner = "chisui";
          repo = "zsh-nix-shell";
          rev = "v0.8.0";
          hash = "sha256-Z6EYQdasvpl1P78poj9efnnLj7QQg13Me8x1Ryyw+dM=";
        };
      }
    ];
    oh-my-zsh = {
      enable = true;
      plugins = [
        "sudo"
      ];
    };
  };
}
