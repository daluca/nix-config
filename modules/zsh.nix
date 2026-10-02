{
  flake.homeModules.zsh =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    {
      programs.zsh = rec {
        enable = true;
        dotDir = "${config.xdg.configHome}/zsh/";
        history = {
          save = 50000;
          size = history.save;
          path = "${config.xdg.dataHome}/zsh/history";
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
        syntaxHighlighting = {
          enable = true;
          highlighters = [
            "brackets"
          ];
        };
        sessionVariables = {
          HISTFILE = history.path;
        };
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
          extraConfig = /* zsh */ ''
            zstyle ':omz:update' mode disabled
            zstyle ':fzf-tab:complete:cd:*' fzf-preview '${lib.getExe config.programs.eza.package} -1 --color=always $realpath'
            zstyle ':fzf-tab:complete:cd:*' popup-min-size 100 20
            zstyle ':fzf-tab:*' fzf-command ftb-tmux-popup
          '';
        };
        profileExtra = /* zsh */ ''
          export DISABLE_TMUX_AUTOSTART=true
        '';

        initContent =
          let
            tmux-autostart = lib.mkBefore /* zsh */ ''
              [[ -n "''${DISABLE_TMUX_AUTOSTART}" ]] || export ZSH_TMUX_AUTOSTART=true
            '';
            transient-prompt = lib.mkAfter /* zsh */ ''
              autoload -Uz add-zle-hook-widget
              add-zle-hook-widget line-finish transient-prompt

              function transient-prompt() {
                PROMPT="$( ${lib.getExe config.programs.starship.package} module character )" RPROMPT="$( ${lib.getExe config.programs.starship.package} module cmd_duration )" zle .reset-prompt
              }
            '';
          in
          lib.mkMerge [
            tmux-autostart
            transient-prompt
          ];
      };

      catppuccin.zsh-syntax-highlighting.enable = true;
    };
}
