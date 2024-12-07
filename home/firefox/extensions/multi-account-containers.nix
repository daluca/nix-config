{ config, pkgs, ... }:
let
  inherit (pkgs.nur.repos.rycee.firefox-addons) multi-account-containers;
in {
  programs.firefox = {
    policies.ExtensionSettings."${multi-account-containers.addonId}" = {
      install_url = "file://${multi-account-containers}/share/mozilla/extensions/{ec8030f7-c20a-464f-9b0e-13a3a9e97384}/${multi-account-containers.addonId}.xpi";
      installation_mode = "force_installed";
    };
  };
}
