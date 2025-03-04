{ pkgs, ... }:

{
  home.packages = with pkgs.unstable; [
    bitwarden-desktop
  ];

  home.persistence.home.directories = [
    ".config/Bitwarden"
  ];
}
