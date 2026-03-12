{ config, lib, pkgs, ... }:

{
  programs.alacritty = {
    enable = true;
    package = pkgs.unstable.alacritty;
    settings = {
      terminal.shell = lib.getExe config.programs.zsh.package;
      font = {
        normal.family = "MonaspiceKr Nerd Font";
        size = 11.0;
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
