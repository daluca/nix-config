{ lib, pkgs, osConfig, ... }:

{
  home.packages = with pkgs.unstable; [
    element-desktop
  ];

  home.persistence.home.directories = lib.mkIf osConfig.environment.persistence.system.enable [
    ".config/Element"
  ];
}
