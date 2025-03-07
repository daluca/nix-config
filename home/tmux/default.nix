{ config, lib, pkgs, ... }:
let
  inherit (lib) toLower;
  inherit (pkgs) tmuxPlugins;
  inherit (config.programs) zsh;
  inherit (config.themes) catppuccin;
in {
  programs.tmux = {
    enable = true;
    shortcut = "a";
    baseIndex = 1;
    secureSocket = true;
    extraConfig = /* tmux */ ''
      # Keybindings
      bind C-r source-file ~/.config/tmux/tmux.conf \; display-message "Config reloaded..."
      bind a send-prefix
      # Plugins
      run-shell ${tmuxPlugins.catppuccin}/share/tmux-plugins/catppuccin/catppuccin.tmux
      run-shell ${tmuxPlugins.yank}/share/tmux-plugins/yank/yank.tmux
      # Config
      set -g @catppuccin_flavour '${toLower catppuccin.flavour}'
    '';
    shell = "${zsh.package}/bin/zsh";
    terminal = "screen-256color";
  };

  programs.zsh.oh-my-zsh.plugins = [
    "tmux"
  ];

  programs.fzf.tmux.enableShellIntegration = true;
}
