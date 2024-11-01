{ config, lib, pkgs, osConfig, ... }:

{
  programs.thunderbird = {
    enable = true;
    package = pkgs.unstable.thunderbird;
    profiles.${config.home.username} = {
      isDefault = true;
    };
  };
}
