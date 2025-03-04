{ pkgs, ... }:

{
  imports = [
    ./mangohud.nix
  ];

  home.packages = with pkgs; [
    mangohud
  ];

  home.persistence.home.directories = [
    ".local/share/Steam"
  ];
}
