{ pkgs, ... }:
let
  inherit (pkgs.nur.repos.rycee.firefox-addons) sponsorblock;
in {
  programs.firefox.policies.ExtensionSettings."${sponsorblock.addonId}" = {
    install_url = "file://${sponsorblock}/share/mozilla/extensions/{ec8030f7-c20a-464f-9b0e-13a3a9e97384}/${sponsorblock.addonId}.xpi";
    installation_mode = "force_installed";
  };
}
