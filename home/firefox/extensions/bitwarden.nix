{ config, pkgs, ... }:
let
  firefox-addons = pkgs.nur.repos.rycee.firefox-addons;
  bitwardenId = firefox-addons.bitwarden.addonId;
in {
  programs.firefox.policies.ExtensionSettings."${bitwardenId}" = {
    install_url = "file://${firefox-addons.bitwarden}/share/mozilla/extensions/{ec8030f7-c20a-464f-9b0e-13a3a9e97384}/${bitwardenId}.xpi";
    installation_mode = "force_installed";
  };
}
