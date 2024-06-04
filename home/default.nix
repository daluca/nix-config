{ config, pkgs, ... }:

{
  imports = [
    ./packages
    ./git
    ./vscodium
    ./tmux
    ./neovim
    ./zsh
    ./alacritty
    ./kubernetes
  ];

  home = {
    username = "daluca";
    homeDirectory = "/home/daluca";

    stateVersion = "24.05";
  };

  programs.home-manager.enable = true;
}
