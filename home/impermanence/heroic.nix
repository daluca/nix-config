{ config, lib, pkgs, ... }:
let
  inherit (lib) mkIf;
  inherit (config) home;
in {
  home.persistence.home.directories = mkIf (builtins.elem pkgs.heroic home.packages || builtins.elem pkgs.unstable.heroic home.packages) [
    ".config/heroic"
    ".local/share/Heroic"
  ];
}
