{ config, lib, ... }:

{
  programs.zsh.initContent = lib.mkAfter /* zsh */ /* bash */ ''
    autoload -Uz add-zle-hook-widget
    add-zle-hook-widget line-finish transient-prompt

    function transient-prompt() {
      PROMPT="$( ${lib.getExe config.programs.starship.package} module character )" RPROMPT="$( ${lib.getExe config.programs.starship.package} module cmd_duration )" zle .reset-prompt
    }
  '';
}
