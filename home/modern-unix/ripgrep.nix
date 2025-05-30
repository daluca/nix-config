{ pkgs, ... }:

{
  programs.ripgrep = {
    enable = true;
    package = pkgs.unstable.ripgrep;
  };

  programs.ripgrep-all = {
    enable = true;
    package = pkgs.unstable.ripgrep-all;
  };
}
