{ pkgs, ... }:
let
  inherit (pkgs.nur.repos.rycee) firefox-addons;
  bypass-paywalls-clean = firefox-addons.bypass-paywalls-clean.override rec {
    version = "4.0.6.0";
    url = "https://gitflic.ru/project/magnolia1234/bpc_uploads/blob/raw?file=bypass_paywalls_clean-${version}.xpi";
    sha256 = "sha256-9OUwo31yyWs352J54xklkR2jMJu9W7r0Ghfksxp+SH8=";
  };
in {
  programs.firefox.policies.ExtensionSettings."${bypass-paywalls-clean.addonId}" = {
    install_url = "file://${bypass-paywalls-clean}/share/mozilla/extensions/{ec8030f7-c20a-464f-9b0e-13a3a9e97384}/${bypass-paywalls-clean.addonId}.xpi";
    installation_mode = "force_installed";
  };
}
