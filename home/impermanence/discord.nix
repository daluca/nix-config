{ config, lib, pkgs, ... }:
let
  inherit (lib) mkIf;
  inherit (config) home;
in {
  home.persistence.home.directories = mkIf (builtins.elem pkgs.discord home.packages || builtins.elem pkgs.unstable.discord) [
    ".config/discord"
  ];
}
