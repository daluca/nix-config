{ pkgs, ... }:

{
  home.packages = [
    pkgs.unstable.signal-desktop
  ];

  home.persistence.home.directories = [
    ".config/Signal"
  ];
}
