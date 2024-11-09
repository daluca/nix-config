{ pkgs, ... }:
let
  inherit (pkgs.nur.repos.rycee.firefox-addons) clearurls;
in {
  programs.firefox.policies.ExtensionSettings."${clearurls.addonId}" = {
    install_url = "file://${clearurls}/share/mozilla/extensions/{ec8030f7-c20a-464f-9b0e-13a3a9e97384}/${clearurls.addonId}.xpi";
    installation_mode = "force_installed";
  };
}
