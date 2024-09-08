{ config, pkgs, ... }:
let
  firefox-addons = pkgs.nur.repos.rycee.firefox-addons;
  sponsorblockId = firefox-addons.sponsorblock.addonId;
in {
  programs.firefox.policies.ExtensionSettings."${sponsorblockId}" = {
    install_url = "file://${firefox-addons.sponsorblock}/share/mozilla/extensions/{ec8030f7-c20a-464f-9b0e-13a3a9e97384}/${sponsorblockId}.xpi";
    installation_mode = "force_installed";
  };
}

