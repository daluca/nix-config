{ pkgs, ... }:

{
  programs.eza = {
    enable = true;
    package = pkgs.unstable.eza;
    enableBashIntegration = false;
    git = true;
    icons = "auto";
    extraOptions = [
      "--group"
      "--binary"
    ];
  };
}
