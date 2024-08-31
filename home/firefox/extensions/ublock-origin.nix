{ config, pkgs, ... }:

{
  programs.firefox.profiles."${config.home.username}".extensions = with pkgs.nur.repos.rycee.firefox-addons; [
    ublock-origin
  ];
}
