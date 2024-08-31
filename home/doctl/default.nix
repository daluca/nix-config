{ lib, pkgs, osConfig, ... }:

{
  home.packages = with pkgs; [ doctl ];

  home.persistence.home = lib.mkIf osConfig.environment.persistence.system.enable {
    directories = [
      ".config/doctl"
    ];
  };
}
