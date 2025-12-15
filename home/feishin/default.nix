{ pkgs, ... }:

{
  home.packages = with pkgs.unstable; [
    feishin
  ];

  home.persistence.home.directories = [
    ".config/feishin"
  ];
}
