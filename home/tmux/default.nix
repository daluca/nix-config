{ config, lib, pkgs, ... }:

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
    mouse = true;
    plugins = with pkgs.tmuxPlugins; [
      yank
      {
        plugin = tmux-sessionx;
        extraConfig = /* tmux */ ''
          set -g @sessionx-bind "C-o"
          set -g @sessionx-prefix "on"
        '';
      }
    ];
    extraConfig = with pkgs.tmuxPlugins; /* tmux */ ''
      # Keybindings
      bind C-r source-file ${config.xdg.configHome}/tmux/tmux.conf \; display-message "Config reloaded..."
      bind a send-prefix
      # Settings
      set -g status-position top
      # Status bar
      set -g status-right-length 100
      set -g status-left-length 100
      set -g status-left ""
      set -g status-right "#{E:@catppuccin_status_application}"
      set -agF status-right "#{E:@catppuccin_status_cpu}"
      set -ag status-right "#{E:@catppuccin_status_session}"
      set -ag status-right "#{E:@catppuccin_status_uptime}"
    '' + lib.optionalString config.host.battery /* tmux */ ''
      set -agF status-right "#{E:@catppuccin_status_battery}"
    '' + /* tmux */ ''
      # Plugins
      run-shell ${cpu}/share/tmux-plugins/cpu/cpu.tmux
      run-shell ${battery}/share/tmux-plugins/battery/battery.tmux
    '';
    shell = lib.getExe config.programs.zsh.package;
    terminal = "screen-256color";
  };

  programs.zsh.sessionVariables = {
    ZSH_TMUX_CONFIG = "${config.xdg.configHome}/tmux/tmux.conf";
  };

  programs.zsh.oh-my-zsh.plugins = [
    "tmux"
  ];

  catppuccin.tmux = {
    enable = true;
    extraConfig = /* tmux */ ''
      set -g @catppuccin_window_status_style "rounded"
      set -g @catppuccin_window_text " #W"
      set -g @catppuccin_window_current_text " #W"
      set -g @catppuccin_pane_active_border_style "##{?pane_in_mode,fg=#{@thm_peach},##{?pane_synchronized,fg=#{@thm_sky},fg=#{@thm_peach}}}" # spellchecker:disable-line
    '';
  };
}
