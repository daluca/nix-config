{ config, ... }:

{
  programs.tmux = {
    enable = true;
    shortcut = "a";
    extraConfig = ''
      bind C-a send-prefix
    '';
  };
}
