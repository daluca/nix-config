{ config, pkgs, ... }:
let
  firefox-addons = pkgs.nur.repos.rycee.firefox-addons;
  simpleloginId = firefox-addons.simplelogin.addonId;
in {
  programs.firefox.policies.ExtensionSettings."${simpleloginId}" = {
    install_url = "file://${firefox-addons.simplelogin}/share/mozilla/extensions/{ec8030f7-c20a-464f-9b0e-13a3a9e97384}/${simpleloginId}.xpi";
    installation_mode = "force_installed";
  };
}
