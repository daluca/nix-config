{ pkgs, ... }:
let
  inherit (pkgs.unstable) signal-desktop-source;
in {
  home.packages = [
    signal-desktop-source
  ];

  home.persistence.home.directories = [
    ".config/Signal"
  ];
}
