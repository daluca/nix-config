{ pkgs, ... }:

{
  home.packages = with pkgs; [
    karere
  ];

  home.persistence.home.directories = [
    ".local/share/karere"
  ];
}
