{ config, pkgs, ... }:

{
  programs.alacritty = {
    enable = true;
    package = pkgs.unstable.alacritty;
    settings = {
      terminal.shell = "${config.programs.zsh.package}/bin/zsh";
      font = let
        font = "MesloLGS Nerd Font";
      in {
        size = 11.0;
	      normal.family = font;
	      bold.family = font;
	      italic.family = font;
	      bold_italic.family = font;
      };
    };
  };

  catppuccin.alacritty.enable = true;

  # TODO: Remove when underlying issue has been fixed
  # https://github.com/NixOS/nixpkgs/issues/22652
  # This is a workaround to for the cursor disappearing over Alacritty
  # https://github.com/alacritty/alacritty/issues/4780#issuecomment-890408502
  home.sessionVariables = {
    XCURSOR_THEME = "Adwaita";
  };
}
