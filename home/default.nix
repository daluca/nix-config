{ config, pkgs, ... }:

{
  imports = [
    ./git
    ./vscodium
    ./tmux
    ./neovim
    ./zsh
    ./alacritty
    ./kubernetes
    ./firefox
    ./dvorak
    ./gnome
  ];

  home = {
    username = "daluca";
    homeDirectory = "/home/daluca";

    stateVersion = "24.05";
  };

  programs.home-manager.enable = true;
}
