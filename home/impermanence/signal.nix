{ config, lib, pkgs, ... }:
let
  inherit (lib) mkIf;
  inherit (config) home;
in {
  home.persistence.home.directories = mkIf (builtins.elem pkgs.signal-desktop home.packages || builtins.elem pkgs.unstable.signal-desktop home.packages) [
    ".config/Signal"
  ];

}
