{ config, pkgs, ... }:
let
  inherit (pkgs) fetchFromGitHub;
  inherit (config.themes) catppuccin;
in {
  programs.bat = {
    enable = true;
    themes."Catppuccin ${catppuccin.flavour}" = {
      src = fetchFromGitHub {
        owner = "catppuccin";
        repo = "bat";
        rev = "d2bbee4f7e7d5bac63c054e4d8eca57954b31471";
        hash = "sha256-x1yqPCWuoBSx/cI94eA+AWwhiSA42cLNUOFJl7qjhmw=";
      };
      file = "themes/Catppuccin ${catppuccin.flavour}.tmTheme";
    };
  };
}
