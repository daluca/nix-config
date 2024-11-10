{ config, lib, pkgs, ... }:
let
  inherit (lib) mkIf toLower;
  inherit (config.programs) zsh fzf;
  inherit (config.themes) catppuccin;
in {
  programs.tmux = {
    enable = true;
    shortcut = "a";
    baseIndex = 1;
    secureSocket = true;
    extraConfig = ''
      bind C-a send-prefix
      run-shell ${pkgs.tmuxPlugins.catppuccin}/share/tmux-plugins/catppuccin/catppuccin.tmux
      set -g @catppuccin_flavour '${toLower catppuccin.flavour}'
    '';
    shell = "${zsh.package}/bin/zsh";
    terminal = "screen-256color";
  };

  programs.zsh.oh-my-zsh.plugins = mkIf ( zsh.enable && zsh.oh-my-zsh.enable ) [
    "tmux"
  ];

  programs.fzf.tmux.enableShellIntegration = mkIf fzf.enable true;
}
