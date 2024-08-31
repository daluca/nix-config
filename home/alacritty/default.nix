{ config, lib, pkgs, osConfig, ... }:
let
  font = "MesloLGS Nerd Font";
  flavour = "mocha";
in {
  programs.alacritty = {
    enable = true;
    package = pkgs.unstable.alacritty;
    settings = {
      shell = "${config.programs.zsh.package}/bin/zsh";
      import = [ (pkgs.fetchFromGitHub {
        owner = "catppuccin";
        repo = "alacritty";
         rev = "343cf8d65459ac8f6449cc98dd3648bcbd7e3766";
        hash = "sha256-5MUWHXs8vfl2/u6YXB4krT5aLutVssPBr+DiuOdMAto=";
      } + "/catppuccin-${flavour}.toml" ) ];
      font = {
        size = 11.0;
	      normal.family = "${font}";
	      bold.family = "${font}";
	      italic.family = "${font}";
	      bold_italic.family = "${font}";
      };
    };
  };

  # TODO: Remove when underlying issue has been fixed
  # https://github.com/NixOS/nixpkgs/issues/22652
  #
  # This is a workaround to for the cursor disappearing over Alacritty
  # https://github.com/alacritty/alacritty/issues/4780#issuecomment-890408502
  home.sessionVariables = lib.mkIf osConfig.services.xserver.desktopManager.gnome.enable {
    XCURSOR_THEME = "Adwaita";
  };
}
