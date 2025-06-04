{ pkgs, ... }:

{
  fonts.fontconfig.enable = true;

  home.packages = with pkgs.nerd-fonts; [
    meslo-lg
    fira-code
  ];
}
