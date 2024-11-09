{ config, pkgs, ... }:
let
  inherit (pkgs.nur.repos.rycee.firefox-addons) multi-account-containers;
  inherit (config.home) username;
in {
  programs.firefox = {
    policies.ExtensionSettings."${multi-account-containers.addonId}" = {
      install_url = "file://${multi-account-containers}/share/mozilla/extensions/{ec8030f7-c20a-464f-9b0e-13a3a9e97384}/${multi-account-containers.addonId}.xpi";
      installation_mode = "force_installed";
    };

    profiles.${username} = {
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
  };
}
