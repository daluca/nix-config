{ config, lib, pkgs, osConfig, ... }:

{
  programs.tmux = {
    enable = true;
    shortcut = "a";
    baseIndex = 1;
    secureSocket = true;
    extraConfig = ''
      bind C-a send-prefix
      run-shell ${pkgs.tmuxPlugins.catppuccin}/share/tmux-plugins/catppuccin/catppuccin.tmux
      set -g @catppuccin_flavour 'mocha'
    '';
    shell = "${config.programs.zsh.package}/bin/zsh";
    terminal = "screen-256color";
  };

  programs.zsh.oh-my-zsh.plugins = lib.mkIf ( config.programs.zsh.enable && config.programs.zsh.oh-my-zsh.enable ) [
    "tmux"
  ];

  programs.zsh.sessionVariables = lib.mkIf ( config.programs.zsh.enable && config.programs.zsh.oh-my-zsh.enable ) {
    ZSH_TMUX_AUTOSTART = "true";
    ZSH_TMUX_DEFAULT_SESSION_NAME = "${osConfig.networking.hostName}";
    ZSH_TMUX_CONFIG = "${config.xdg.configHome}/tmux/tmux.conf";
  };

  programs.fzf.tmux.enableShellIntegration = lib.mkIf config.programs.fzf.enable true;
}
