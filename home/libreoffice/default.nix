{ pkgs, ... }:

{
  home.packages = with pkgs; [
    libreoffice
  ];

  home.persistence.home.directories = [
    ".config/libreoffice"
  ];
}
