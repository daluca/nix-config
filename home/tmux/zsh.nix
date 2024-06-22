{
  config,
  lib,
  hostname,
  ...
}:

{
  programs.zsh.oh-my-zsh = lib.mkIf config.programs.zsh.enable { plugins = [ "tmux" ]; };

  home.sessionVariables = lib.mkIf config.programs.zsh.enable {
    ZSH_TMUX_AUTOSTART = "true";
    ZSH_TMUX_DEFAULT_SESSION_NAME = "${hostname}";
    ZSH_TMUX_CONFIG = "$HOME/.config/tmux/tmux.conf";
  };
}
