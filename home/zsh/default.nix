{ config, ... }:

{
  imports = [
    ./ohmyzsh.nix
    ./starship.nix
  ];

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
  };
}
