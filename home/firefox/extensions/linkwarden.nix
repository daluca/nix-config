{ pkgs, ... }:
let
  inherit (pkgs.nur.repos.rycee.firefox-addons) linkwarden;
in {
  programs.firefox.policies.ExtensionSettings."${linkwarden.addonId}" = {
    install_url = "file://${linkwarden}/share/mozilla/extensions/{ec8030f7-c20a-464f-9b0e-13a3a9e97384}/${linkwarden.addonId}.xpi";
    installation_mode = "force_installed";
  };
}
