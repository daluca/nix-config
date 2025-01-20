{ pkgs, ... }:
let
  inherit (pkgs.unstable) btop;
in {
  programs.btop = {
    enable = true;
    package = btop;
  };

  catppuccin.btop.enable = true;
}
