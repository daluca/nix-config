{ pkgs, ... }:
let
  inherit (pkgs.unstable) signal-desktop;
in {
  home.packages = [
    signal-desktop
  ];
}
