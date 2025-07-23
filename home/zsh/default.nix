{ config, lib, pkgs, ... }:

{
  programs.zsh = rec {
    enable = true;
    dotDir = ".config/zsh";
    history = {
      save = 50000;
      size = history.save;
      path = "${config.home.homeDirectory}/${dotDir}/.zsh_history";
      share = true;
      append = true;
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
      extraConfig = /* zsh */ /* bash */ ''
        zstyle ':omz:update' mode disabled
      '';
    };
    profileExtra = /* zsh */ /* bash */ ''
      export DISABLE_TMUX_AUTOSTART=true
    '';
    initContent = lib.mkOrder 500 /* zsh */ /* bash */ ''
      [[ -n "''${DISABLE_TMUX_AUTOSTART}" ]] || export ZSH_TMUX_AUTOSTART=true

      autoload -Uz add-zle-hook-widget
      add-zle-hook-widget line-finish transient-prompt

      function transient-prompt() {
        PROMPT="$( starship module character )" RPROMPT="" zle .reset-prompt
      }
    '';
  };

  catppuccin.zsh-syntax-highlighting.enable = true;
}
