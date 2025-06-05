{ config, pkgs, ... }:

rec {
  programs.atuin = {
    enable = true;
    package = pkgs.unstable.atuin;
    enableBashIntegration = false;
    daemon.enable = true;
    settings = {
      dialect = "uk";
      inline_height = 14;
      update_check = false;
      keymap_mode = "vim-insert";
    };
  };

  catppuccin.atuin.enable = true;

  programs.zsh.initContent = /* zsh */ /* bash */ ''
    atuin-setup() {
      bindkey '^[r' atuin-search

      export ATUIN_NOBIND="true"

      fzf-atuin-history-widget() {
        local selected
        setopt localoptions noglobsubst noposixbuiltins pipefail no_aliases

        selected=$(
          eval ${programs.atuin.package}/bin/atuin search --cmd-only --reverse | ${config.programs.fzf.package}/bin/fzf --tmux center,60%,border-native
        )
        local ret=$?
        if [ -n "$selected" ]; then
          LBUFFER+="''${selected}"
        fi
        zle reset-prompt
        return $ret
      }

      zle -N fzf-atuin-history-widget
      bindkey '^R' fzf-atuin-history-widget
      bindkey '^[OA' atuin-up-search
    }

    atuin-setup
  '';

  programs.ghostty.settings = {
    keybind = [
      "alt+one=unbind"
      "alt+two=unbind"
      "alt+three=unbind"
      "alt+four=unbind"
      "alt+five=unbind"
      "alt+six=unbind"
      "alt+seven=unbind"
      "alt+eight=unbind"
      "alt+nine=unbind"
    ];
  };

  home.persistence.home.directories = [
    ".local/share/atuin"
  ];
}
