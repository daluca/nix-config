{ config, lib, ... }:

{
  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
    config = {
      strict_env = true;
      hide_env_diff = true;
      warn_timeout = "30s";
      whitelist.prefix = [
        "${config.home.homeDirectory}/code/github.com/daluca"
      ];
    };
  };

  programs.zsh.oh-my-zsh.plugins = lib.mkIf ( config.programs.zsh.enable && config.programs.zsh.oh-my-zsh.enable ) [
    "direnv"
  ];
}
