{ inputs, outputs, ... }:

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

  nixpkgs.overlays = builtins.attrValues outputs.overlays ++ [
    inputs.nur.overlays.default
    inputs.nix-vscode-extensions.overlays.default
  ];

  xdg.enable = true;

  home.stateVersion = "24.11";

  programs.home-manager.enable = true;
}
