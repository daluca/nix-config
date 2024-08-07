{
  config,
  pkgs,
  username,
  ...
}:

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
    ./firefox
    ./dvorak
    ./gnome
    ./development
    ./terraform
    ./zoxide
    ./ansible
    ./atuin
    ./xdg
    ./ssh
    ./neovide
    ./uutils
    ./element
    ./signal
    ./logseq
  ];

  home = {
    username = "${username}";
    homeDirectory = "/home/${username}";

    stateVersion = "24.05";
  };

  programs.home-manager.enable = true;
}
