{ pkgs, ... }:
let
  inherit (pkgs.nur.repos.rycee.firefox-addons) consent-o-matic;
in {
  programs.firefox.policies.ExtensionSettings."${consent-o-matic.addonId}" = {
    install_url = "file://${consent-o-matic}/share/mozilla/extensions/{ec8030f7-c20a-464f-9b0e-13a3a9e97384}/${consent-o-matic.addonId}.xpi";
    installation_mode = "force_installed";
  };
}
