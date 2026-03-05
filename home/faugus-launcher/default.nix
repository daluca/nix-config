{ pkgs, ... }:

{
  home.packages = with pkgs; [
    faugus-launcher
  ];

  home.persistence.home.directories = [
    ".config/faugus-launcher"
    ".local/share/faugus-launcher"
    ".local/share/umu"
  ];
}
