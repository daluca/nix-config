{ config, pkgs, ... }:
let
  flavour = "mocha";
in {
  programs.btop = {
    enable = true;
    package = pkgs.unstable.btop;
    settings = {
      color_theme = "${config.xdg.configHome}/btop/themes/catppuccin_${flavour}.theme";
    };
  };

  xdg.configFile."btop/themes".source = (pkgs.fetchFromGitHub {
    owner = "catppuccin";
    repo = "btop";
    rev = "21b8d5956a8b07fa52519e3267fb3a2d2e693d17";
    hash = "sha256-UXeTypc15MhjgGUiCrDUZ40m32yH2o1N+rcrEgY6sME=";
  } + "/themes");
}
