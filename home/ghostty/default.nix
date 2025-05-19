{ config, pkgs, ... }:

{
  programs.ghostty = {
    enable = true;
    package = pkgs.unstable.ghostty;
    enableZshIntegration = true;
    settings = let
      font = "MesloLGS Nerd Font";
    in {
      command = "${config.programs.zsh.package}/bin/zsh";
      font-size = 11;
      font-family = font;
      font-family-bold = font;
      font-family-italic = font;
      font-family-bold-italic = font;
    };
  };

  catppuccin.ghostty.enable = true;
}
