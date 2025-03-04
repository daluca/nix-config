{ pkgs, ... }:
let
  inherit (pkgs) discord;
in {
  home.packages = [
    discord
  ];

  home.persistence.home.directories = [
    ".config/discord"
  ];
}
