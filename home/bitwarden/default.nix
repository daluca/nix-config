{ pkgs, ... }:

{
  home.packages = with pkgs.unstable; [
    bitwarden-desktop
    bitwarden-cli
  ];

  home.persistence.home.directories = [
    ".config/Bitwarden"
  ];
}
