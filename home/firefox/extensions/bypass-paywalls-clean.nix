{ pkgs, ... }:
let
  inherit (pkgs) bypass-paywalls-clean;
in {
  programs.firefox.policies.ExtensionSettings."${bypass-paywalls-clean.addonId}" = {
    install_url = "file://${bypass-paywalls-clean}/share/mozilla/extensions/{ec8030f7-c20a-464f-9b0e-13a3a9e97384}/${bypass-paywalls-clean.addonId}.xpi";
    installation_mode = "force_installed";
  };
}
