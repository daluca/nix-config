{ config, pkgs, ... }:
let
  plugins = pkgs.tmuxPlugins;
in
{
  imports = [ ./zsh.nix ];

  programs.tmux = {
    enable = true;
    shortcut = "a";
    baseIndex = 1;
    secureSocket = true;
    extraConfig = ''
      bind C-a send-prefix
      run-shell ${plugins.catppuccin}/share/tmux-plugins/catppuccin/catppuccin.tmux
      set -g @catppuccin_flavour 'mocha'
    '';
  };
}
