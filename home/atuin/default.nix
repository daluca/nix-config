{ config, pkgs, ... }:

rec {
  programs.atuin = {
    enable = true;
    package = pkgs.unstable.atuin;
    enableBashIntegration = false;
    settings = {
      dialect = "uk";
      update_check = false;
    };
  };

  catppuccin.atuin.enable = true;

  programs.zsh.initContent = /* zsh */ /* bash */ ''
    atuin-setup() {
      bindkey '^E' _atuin_search_widget

      export ATUIN_NOBIND="true"

      fzf-atuin-history-widget() {
        local selected
        setopt localoptions noglobsubst noposixbuiltins pipefail no_aliases

        selected=$(
          eval ${programs.atuin.package}/bin/atuin search --cmd-only --reverse | ${config.programs.fzf.package}/bin/fzf --tmux center,60%,40%,border-native
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
    }

    atuin-setup
  '';

  home.persistence.home.directories = [
    ".local/share/atuin"
  ];
}
