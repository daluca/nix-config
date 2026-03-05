{ pkgs, ... }:

{
  home.packages = with pkgs; [
    itch
  ];

  home.persistence.home.directories = [
    ".config/itch"
    ".local/share/itch"
  ];
}
