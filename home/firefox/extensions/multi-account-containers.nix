{ config, pkgs, ... }:

{
  programs.firefox.profiles."${config.home.username}" = {
    extensions = with pkgs.nur.repos.rycee.firefox-addons; [
      multi-account-containers
    ];
    containersForce = true;
    containers = {
      "001-personal" = {
        id = 1;
        name = "Personal";
        icon = "fingerprint";
        color = "blue";
      };
      "002-work" = {
        id = 2;
        name = "Work";
        icon = "briefcase";
        color = "orange";
      };
      "003-banking" = {
        id = 3;
        name = "Banking";
        icon = "dollar";
        color = "green";
      };
      "004-shopping" = {
        id = 4;
        name = "Shopping";
        icon = "cart";
        color = "pink";
      };
      "005-google" = {
        id = 5;
        name = "Google";
        icon = "fence";
        color = "green";
      };
      "006-facebook" = {
        id = 6;
        name = "Facebook";
        icon = "tree";
        color = "blue";
      };
    };
  };
}
