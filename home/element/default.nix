{ pkgs, ... }:

{
  home.packages = with pkgs.unstable; [
    element-desktop
  ];

  home.persistence.home.directories = [
    ".config/Element"
  ];
}
