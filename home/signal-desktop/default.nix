{ pkgs, ... }:
let
  inherit (pkgs.unstable) signal-desktop;
in {
  home.packages = [
    signal-desktop
  ];

  home.persistence.home.directories = [
    ".config/Signal"
  ];
}
