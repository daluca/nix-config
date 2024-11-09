{ pkgs, ... }:
let
  inherit (pkgs.nur.repos.rycee.firefox-addons) stylus;
in {
  programs.firefox.policies.ExtensionSettings."${stylus.addonId}" = {
    install_url = "file://${stylus}/share/mozilla/extensions/{ec8030f7-c20a-464f-9b0e-13a3a9e97384}/${stylus.addonId}.xpi";
    installation_mode = "force_installed";
  };
}
