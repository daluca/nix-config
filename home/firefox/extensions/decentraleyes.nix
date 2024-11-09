{ pkgs, ... }:
let
  inherit (pkgs.nur.repos.rycee.firefox-addons) decentraleyes;
in {
  programs.firefox = {
    policies.ExtensionSettings."${decentraleyes.addonId}" = {
      install_url = "file://${decentraleyes}/share/mozilla/extensions/{ec8030f7-c20a-464f-9b0e-13a3a9e97384}/${decentraleyes.addonId}.xpi";
      installation_mode = "force_installed";
    };
  };
}
