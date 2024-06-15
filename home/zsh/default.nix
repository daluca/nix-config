{ config, ... }:

{
  imports = [
    ./ohmyzsh.nix
    ../starship
  ];

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
  };
}
