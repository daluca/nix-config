{ pkgs, ... }:

{
  fonts.packages = with pkgs; [
    monaspace
    nerd-fonts.monaspace
    nerd-fonts.symbols-only
  ];
}
