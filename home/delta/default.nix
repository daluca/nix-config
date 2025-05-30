{ config, lib, pkgs, ... }:
let
  inherit (lib) toLower;
  inherit (pkgs) fetchFromGitHub;
  inherit (pkgs.unstable) delta;
  inherit (config.themes) catppuccin;
in {

  programs.git = {
    delta = {
      enable = true;
      package = delta;
      options = {
        line-numbers = true;
      };
    };
  };

  catppuccin.delta.enable = true;
}
