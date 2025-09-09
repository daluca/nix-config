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
        name = "nix-shell";
        src = "${pkgs.zsh-nix-shell}/share/zsh-nix-shell";
      }
      {
        name = "fzf-tab";
        src = "${pkgs.zsh-fzf-tab}/share/fzf-tab";
      }
    ];
    oh-my-zsh = {
      enable = true;
      plugins = [
        "sudo"
      ];
      extraConfig = /* zsh */ /* bash */ ''
        zstyle ':omz:update' mode disabled
        zstyle ':fzf-tab:complete:cd:*' fzf-preview 'eza -1 --color=always $realpath'
        zstyle ':fzf-tab:complete:cd:*' popup-min-size 100 20
        zstyle ':fzf-tab:*' fzf-command ftb-tmux-popup
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
