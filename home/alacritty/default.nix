{ config, pkgs, ... }:
let
  font = "MesloLGS Nerd Font";
  theme = "catppuccin-mocha";
in
{
  programs.alacritty = {
    enable = true;
    package = pkgs.unstable.alacritty;
    settings = {
      import = [ "~/.config/alacritty/themes/${theme}.toml" ];
      font.size = 11.0;
      font.normal.family = "${font}";
      font.bold.family = "${font}";
      font.italic.family = "${font}";
      font.bold_italic.family = "${font}";
    };
  };

  xdg.configFile."alacritty/themes".source = pkgs.fetchFromGitHub {
    owner = "catppuccin";
    repo = "alacritty";
    rev = "94800165c13998b600a9da9d29c330de9f28618e";
    hash = "sha256-Pi1Hicv3wPALGgqurdTzXEzJNx7vVh+8B9tlqhRpR2Y=";
  };
}
