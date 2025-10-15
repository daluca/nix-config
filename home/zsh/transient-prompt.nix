{ lib, ... }:

{
  programs.zsh.initContent = lib.mkAfter /* zsh */ /* bash */ ''
    autoload -Uz add-zle-hook-widget
    add-zle-hook-widget line-finish transient-prompt

    function transient-prompt() {
      PROMPT="$( starship module character )" RPROMPT="$( starship module cmd_duration )" zle .reset-prompt
    }
  '';
}
