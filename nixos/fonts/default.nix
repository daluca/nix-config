{ pkgs, ... }:

{
  fonts.packages = with pkgs.nerd-fonts; [
    meslo-lg
    fira-code
    pkgs.monaspace
  ];
}
