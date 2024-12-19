{ config, lib, pkgs, ... }:
let
  inherit (lib) mkIf;
  inherit (config) home;
in {
  home.persistence.home.directories = mkIf (builtins.elem pkgs.protonmail-bridge home.packages || builtins.elem pkgs.unstable.protonmail-bridge home.packages) [
    ".config/protonmail/bridge-v3"
    ".local/share/protonmail/bridge-v3"
  ];

}
