{ config, pkgs, ... }:
let
  firefox-addons = pkgs.nur.repos.rycee.firefox-addons;
  decentraleyesId = firefox-addons.decentraleyes.addonId;
in {
  programs.firefox = {
    profiles."${config.home.username}".extensions = with firefox-addons; [
      decentraleyes
    ];
    policies.ExtensionSettings."${decentraleyesId}" = {
      install_url = "file://${firefox-addons.decentraleyes}/share/mozilla/extensions/{ec8030f7-c20a-464f-9b0e-13a3a9e97384}/${decentraleyesId}";
      installation_mode = "force_installed";
    };
  };
}