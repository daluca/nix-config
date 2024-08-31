{ config, osConfig, ... }:

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
    oh-my-zsh = {
      enable = true;
      plugins = [
        "sudo"
      ];
    };
  };
}
