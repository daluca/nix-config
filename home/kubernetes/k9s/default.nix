{ pkgs, ... }:
let
  flavour = "mocha";
in {
  programs.k9s = {
    enable = true;
    package = pkgs.unstable.k9s;
    settings.k9s = {
      ui = {
        enableMouse = false;
        logoless = true;
        skin = "catppuccin-${flavour}";
      };
      skipLatestRevCheck = true;
    };
  };

  xdg.configFile."k9s/skins".source = pkgs.fetchFromGitHub {
    owner = "catppuccin";
    repo = "k9s";
    rev = "fdbec82284744a1fc2eb3e2d24cb92ef87ffb8b4";
    hash = "sha256-9h+jyEO4w0OnzeEKQXJbg9dvvWGZYQAO4MbgDn6QRzM=";
  } + "/dist/";
}
