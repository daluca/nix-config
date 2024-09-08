{ config, pkgs, ... }:
let
  firefox-addons = pkgs.nur.repos.rycee.firefox-addons;
  stylusId = firefox-addons.stylus.addonId;
in {
  programs.firefox.policies.ExtensionSettings."${stylusId}" = {
    install_url = "file://${firefox-addons.stylus}/share/mozilla/extensions/{ec8030f7-c20a-464f-9b0e-13a3a9e97384}/${stylusId}.xpi";
    installation_mode = "force_installed";
  };
}
