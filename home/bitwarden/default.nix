{ lib, pkgs, osConfig, ... }:

{
  home.packages = with pkgs.unstable; [
    bitwarden-desktop
  ];

  home.persistence.home.directories = lib.mkIf osConfig.environment.persistence.system.enable [
    ".config/Bitwarden"
  ];
}
