{ inputs, outputs, ... }:

{
  imports = [
    outputs.homeManagerModules.themes

    ../tmux
    ../dvorak
    ../zsh
    ../starship
    ../openssh
    ../secrets
    ../git
  ];

  themes.catppuccin.flavour = "Mocha";

  home.username = "daluca";
  home.homeDirectory = "/home/daluca";

  programs.bash.enable = true;

  nixpkgs.overlays = builtins.attrValues outputs.overlays ++ [
    inputs.nur.overlay
  ];

  xdg.enable = true;

  home.stateVersion = "24.05";

  programs.home-manager.enable = true;
}
