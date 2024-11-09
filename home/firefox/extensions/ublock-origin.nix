{ pkgs, ... }:
let
  inherit (pkgs.nur.repos.rycee.firefox-addons) ublock-origin;
in
{
  programs.firefox.policies.ExtensionSettings."${ublock-origin.addonId}" = {
    install_url = "file://${ublock-origin}/share/mozilla/extensions/{ec8030f7-c20a-464f-9b0e-13a3a9e97384}/${ublock-origin.addonId}.xpi";
    installation_mode = "force_installed";
  };
}
