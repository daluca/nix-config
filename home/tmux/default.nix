{ config, ... }:

{
  imports = [ ./zsh.nix ];

  programs.tmux = {
    enable = true;
    shortcut = "a";
    baseIndex = 1;
    secureSocket = true;
    extraConfig = ''
      bind C-a send-prefix
    '';
  };
}
