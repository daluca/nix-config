{
  config,
  lib,
  osConfig,
  ...
}:

{
  programs.zsh.oh-my-zsh = lib.mkIf config.programs.zsh.enable { plugins = [ "tmux" ]; };

  home.sessionVariables = lib.mkIf config.programs.zsh.enable {
    ZSH_TMUX_AUTOSTART = "true";
    ZSH_TMUX_DEFAULT_SESSION_NAME = "${osConfig.networking.hostName}";
    ZSH_TMUX_CONFIG = "$XDG_CONFIG_HOME/tmux/tmux.conf";
  };
}
