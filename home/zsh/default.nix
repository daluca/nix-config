{ config, pkgs, osConfig, ... }:

{
  programs.zsh = rec {
    enable = true;
    dotDir = ".config/zsh";
    history = {
      save = 50000;
      size = history.save;
      path =
        if osConfig.environment.persistence.system.enable && dotDir != null then
          "${config.home.persistence.home.persistentStoragePath}/${dotDir}/.zsh_history"
        else if osConfig.environment.persistence.system.enable then
          "${config.home.persistence.home.persistentStoragePath}/.zsh_history"
        else if dotDir != null then
          "${config.home.homeDirectory}/${dotDir}/.zsh_history"
        else
          "${config.home.homeDirectory}/.zsh_history";
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
        src = pkgs.fetchFromGitHub {
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
