{ pkgs, ... }:
let
  inherit (pkgs.nur.repos.rycee.firefox-addons) simplelogin;
in {
  programs.firefox.policies.ExtensionSettings."${simplelogin.addonId}" = {
    install_url = "file://${simplelogin}/share/mozilla/extensions/{ec8030f7-c20a-464f-9b0e-13a3a9e97384}/${simplelogin.addonId}.xpi";
    installation_mode = "force_installed";
  };
}
