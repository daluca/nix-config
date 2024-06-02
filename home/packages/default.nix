{ pkgs, ... }:

{
  home.packages = with pkgs; [
    firefox
    unstable.alacritty
  ];
}
