{ config, ... }:

{
  programs.tmux = {
    enable = true;
    shortcut = "a";
    baseIndex = 1;
    extraConfig = ''
      bind C-a send-prefix
    '';
  };
}
