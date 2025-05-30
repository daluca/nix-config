{ pkgs, ... }:

{
  programs.eza = {
    enable = true;
    package = pkgs.unstable.eza;
    enableBashIntegration = false;
  };
}
