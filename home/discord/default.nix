{ pkgs, ... }:
let
  inherit (pkgs) discord;
in {
  home.packages = [
    discord
  ];
}
