{ config, pkgs, ... }:
let
  firefox-addons = pkgs.nur.repos.rycee.firefox-addons;
  ublock-originId = firefox-addons.ublock-origin.addonId;
in
{
  programs.firefox = {
    policies.ExtensionSettings."${ublock-originId}" = {
      install_url = "file://${firefox-addons.ublock-origin}/share/mozilla/extensions/{ec8030f7-c20a-464f-9b0e-13a3a9e97384}/${ublock-originId}.xpi";
      installation_mode = "force_installed";
    };
  };
}
