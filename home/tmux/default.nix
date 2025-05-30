{ config, pkgs, ... }:

{
  programs.tmux = {
    enable = true;
    shortcut = "a";
    baseIndex = 1;
    historyLimit = 50000;
    secureSocket = true;
    clock24 = true;
    sensibleOnTop = true;
    keyMode = "vi";
    plugins = with pkgs.tmuxPlugins; [
      yank
    ];
    extraConfig = with pkgs.tmuxPlugins; /* tmux */ ''
      # Keybindings
      bind C-r source-file ${config.xdg.configHome}/tmux/tmux.conf \; display-message "Config reloaded..."
      bind a send-prefix
      # Status bar
      set -g status-right-length 100
      set -g status-left-length 100
      set -g status-left ""
      set -g status-right "#{E:@catppuccin_status_application}"
      set -agF status-right "#{E:@catppuccin_status_cpu}"
      set -ag status-right "#{E:@catppuccin_status_session}"
      set -ag status-right "#{E:@catppuccin_status_uptime}"
      set -agF status-right "#{E:@catppuccin_status_battery}"
      # Plugins
      run-shell ${cpu}/share/tmux-plugins/cpu/cpu.tmux
      run-shell ${battery}/share/tmux-plugins/battery/battery.tmux
    '';
    shell = "${config.programs.zsh.package}/bin/zsh";
    terminal = "screen-256color";
  };

  programs.zsh = {
    sessionVariables = {
      ZSH_TMUX_CONFIG = "${config.xdg.configHome}/tmux/tmux.conf";
    };
    oh-my-zsh.plugins = [
      "tmux"
    ];
  };

  catppuccin.tmux = {
    enable = true;
    extraConfig = /* tmux */ ''
      set -g @catppuccin_window_status_style "rounded"
    '';
  };

  programs.fzf.tmux.enableShellIntegration = true;
}
