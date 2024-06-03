{ config, pkgs, ... }:
let
  font = "MesloLGS Nerd Font";
in
{
  programs.alacritty = {
    enable = true;
    package = pkgs.unstable.alacritty;
    settings = {
      font.size = 11.0;
      font.normal.family = "${font}";
      font.bold.family = "${font}";
      font.italic.family = "${font}";
      font.bold_italic.family = "${font}";
    };
  };
}
