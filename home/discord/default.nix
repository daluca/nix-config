{ lib, pkgs, ... }:
let
  inherit (lib) getName;
  inherit (pkgs) discord;
in {
  home.packages = [
    discord
  ];

  nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (getName pkg) [
    "discord"
  ];
}
