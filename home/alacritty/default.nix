{ config, lib, pkgs, osConfig, ... }:
let
  inherit (pkgs.unstable) alacritty;
  inherit (lib) mkIf;
  inherit (config.programs) zsh;
  inherit (osConfig.services.xserver.desktopManager) gnome;
  font = "MesloLGS Nerd Font";
in {
  programs.alacritty = {
    enable = true;
    package = alacritty;
    settings = {
      terminal.shell = "${zsh.package}/bin/zsh";
      font = {
        size = 11.0;
	      normal.family = "${font}";
	      bold.family = "${font}";
	      italic.family = "${font}";
	      bold_italic.family = "${font}";
      };
    };
  };

  catppuccin.alacritty.enable = true;

  # TODO: Remove when underlying issue has been fixed
  # https://github.com/NixOS/nixpkgs/issues/22652
  #
  # This is a workaround to for the cursor disappearing over Alacritty
  # https://github.com/alacritty/alacritty/issues/4780#issuecomment-890408502
  home.sessionVariables = mkIf gnome.enable {
    XCURSOR_THEME = "Adwaita";
  };
}
