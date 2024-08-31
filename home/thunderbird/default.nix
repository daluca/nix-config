{ config, lib, pkgs, osConfig, ... }:

{
  programs.thunderbird = {
    enable = true;
    package = pkgs.unstable.thunderbird;
    profiles.${config.home.username} = {
      isDefault = true;
    };
  };

  home.persistence.home = lib.mkIf osConfig.environment.persistence.system.enable {
    directories = [
      ".thunderbird"
    ];
  };
}
