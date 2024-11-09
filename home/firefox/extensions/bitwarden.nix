{ pkgs, ... }:
let
  inherit (pkgs.nur.repos.rycee.firefox-addons) bitwarden;
in {
  programs.firefox.policies.ExtensionSettings."${bitwarden.addonId}" = {
    install_url = "file://${bitwarden}/share/mozilla/extensions/{ec8030f7-c20a-464f-9b0e-13a3a9e97384}/${bitwarden.addonId}.xpi";
    installation_mode = "force_installed";
  };
}
