{ pkgs, ... }:

{
  programs.bat = {
    enable = true;
    package = pkgs.unstable.bat;
  };

  catppuccin.bat.enable = true;
}
