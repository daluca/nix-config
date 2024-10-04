{ lib, pkgs, osConfig, ... }:

{
  imports = [
    ./mangohud.nix
  ];

  home.packages = with pkgs; [
    mangohud
  ];

  home.persistence.home.directories = lib.mkIf osConfig.environment.persistence.system.enable [
    ".local/share/Steam"
  ];
}
