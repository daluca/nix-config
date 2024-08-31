{ pkgs, ... }:

{
  home.packages = with pkgs.unstable; [
    libreoffice
  ];
}
