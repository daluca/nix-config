{ config, lib, pkgs, ... }:
let
  inherit (lib) toLower;
  inherit (pkgs) fetchFromGitHub;
  inherit (pkgs.unstable) btop;
  inherit (config) xdg;
  inherit (config.themes) catppuccin;
in {
  programs.btop = {
    enable = true;
    package = btop;
    settings = {
      color_theme = "${xdg.configHome}/btop/themes/catppuccin_${toLower catppuccin.flavour}.theme";
    };
  };

  xdg.configFile."btop/themes".source = (fetchFromGitHub {
    owner = "catppuccin";
    repo = "btop";
    rev = "21b8d5956a8b07fa52519e3267fb3a2d2e693d17";
    hash = "sha256-UXeTypc15MhjgGUiCrDUZ40m32yH2o1N+rcrEgY6sME=";
  } + "/themes");
}
