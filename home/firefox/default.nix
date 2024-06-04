{ config, pkgs, ... }:

{
  programs.firefox = {
    enable = true;
    profiles.daluca = {
      isDefault = true;
      extensions = with pkgs.nur.repos.rycee.firefox-addons; [
        ublock-origin
        bitwarden
      ];
    };
  };
}
