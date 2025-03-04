{ outputs, ... }:

{
  imports = builtins.attrValues outputs.homeManagerModules ++ [
    ./tmux
    ./dvorak
    ./zsh
    ./starship
    ./openssh
    ./secrets
    ./catppuccin
  ];

  programs.bash.enable = true;

  xdg.enable = true;

  home.stateVersion = "24.11";

  programs.home-manager.enable = true;
}
