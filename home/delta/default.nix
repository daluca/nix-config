{ config, lib, pkgs, ... }:
let
  inherit (lib) toLower;
  inherit (pkgs) fetchFromGitHub;
  inherit (pkgs.unstable) delta;
  inherit (config.themes) catppuccin;
in {
  imports = [
    ../bat
  ];

  programs.git = {
    includes = [{
      path = fetchFromGitHub {
        owner = "catppuccin";
        repo = "delta";
        rev = "0674ec5114c08393d808e2516d153c7e6df00d41";
        hash = "sha256-JvkTvAe1YltgmYSHeewzwg6xU38oGOIYoehXdHwW1zI=";
      } + "/catppuccin.gitconfig";
    }];
    delta = {
      enable = true;
      package = delta;
      options = {
        features = "catppuccin-${toLower catppuccin.flavour}";
        line-numbers = true;
      };
    };
  };
}
