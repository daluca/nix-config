{ config, lib, pkgs }:

with pkgs; with pkgs.nur.repos.rycee.firefox-addons; {
  ExtensionUpdate = false;

  ExtensionSettings = {
    "*".installation_mode = "blocked";
    ${ublock-origin.addonId} = {
      install_url = "file://${ublock-origin}/share/mozilla/extensions/{ec8030f7-c20a-464f-9b0e-13a3a9e97384}/${ublock-origin.addonId}.xpi";
      installation_mode = "force_installed";
    };
    ${bitwarden.addonId} = {
      install_url = "file://${bitwarden}/share/mozilla/extensions/{ec8030f7-c20a-464f-9b0e-13a3a9e97384}/${bitwarden.addonId}.xpi";
      installation_mode = "force_installed";
    };
    ${sponsorblock.addonId} = {
      install_url = "file://${sponsorblock}/share/mozilla/extensions/{ec8030f7-c20a-464f-9b0e-13a3a9e97384}/${sponsorblock.addonId}.xpi";
      installation_mode = "force_installed";
    };
    ${multi-account-containers.addonId} = {
      install_url = "file://${multi-account-containers}/share/mozilla/extensions/{ec8030f7-c20a-464f-9b0e-13a3a9e97384}/${multi-account-containers.addonId}.xpi";
      installation_mode = "force_installed";
    };
    ${stylus.addonId} = {
      install_url = "file://${stylus}/share/mozilla/extensions/{ec8030f7-c20a-464f-9b0e-13a3a9e97384}/${stylus.addonId}.xpi";
      installation_mode = "force_installed";
    };
    ${decentraleyes.addonId} = {
      install_url = "file://${decentraleyes}/share/mozilla/extensions/{ec8030f7-c20a-464f-9b0e-13a3a9e97384}/${decentraleyes.addonId}.xpi";
      installation_mode = "force_installed";
    };
    ${simplelogin.addonId} = {
      install_url = "file://${simplelogin}/share/mozilla/extensions/{ec8030f7-c20a-464f-9b0e-13a3a9e97384}/${simplelogin.addonId}.xpi";
      installation_mode = "force_installed";
    };
    ${clearurls.addonId} = {
      install_url = "file://${clearurls}/share/mozilla/extensions/{ec8030f7-c20a-464f-9b0e-13a3a9e97384}/${clearurls.addonId}.xpi";
      installation_mode = "force_installed";
    };
    ${linkwarden.addonId} = {
      install_url = "file://${linkwarden}/share/mozilla/extensions/{ec8030f7-c20a-464f-9b0e-13a3a9e97384}/${linkwarden.addonId}.xpi";
      installation_mode = "force_installed";
    };
    ${consent-o-matic.addonId} = {
      install_url = "file://${consent-o-matic}/share/mozilla/extensions/{ec8030f7-c20a-464f-9b0e-13a3a9e97384}/${consent-o-matic.addonId}.xpi";
      installation_mode = "force_installed";
    };
  } // lib.optionalAttrs (! config.host.work) {
    ${bypass-paywalls-clean.addonId} = {
      install_url = "file://${bypass-paywalls-clean}/share/mozilla/extensions/{ec8030f7-c20a-464f-9b0e-13a3a9e97384}/${bypass-paywalls-clean.addonId}.xpi";
      installation_mode = "force_installed";
    };
  };

  "3rdparty".Extensions.${ublock-origin.addonId}.adminSettings =
  let
    hide-youtube-short = "https://github.com/gijsdev/ublock-hide-yt-shorts/raw/refs/tags/v1.10.0/list.txt";
  in {
    userSettings = {
      importedLists = [
        hide-youtube-short
      ];
      externalLists = hide-youtube-short;
    };
    selectedFilterLists = [
      "user-filters"
      "ublock-filters"
      "ublock-badware"
      "ublock-privacy"
      "ublock-quick-fixes"
      "ublock-unbreak"
      "easylist"
      "easyprivacy"
      "urlhaus-1"
      "plowe-0"
      "easylist-chat"
      "easylist-newsletters"
      "easylist-notifications"
      "easylist-annoyances"
      hide-youtube-short
    ];
    userFilters = let
      youtube-rows = builtins.toString 5;
    in lib.concatStringsSep "\n" [
      "youtube.com##ytd-rich-grid-row, #contents.ytd-rich-grid-row:style(display:contents !important;)"
      "youtube.com##ytd-rich-grid-renderer, html:style(--ytd-rich-grid-items-per-row: ${youtube-rows} !important;)"
      "youtube.com##ytd-rich-grid-renderer, html:style(--ytd-rich-grid-posts-per-row: ${youtube-rows} !important;)"
      "youtube.com##ytd-browse[page-subtype=\"home\"] ytd-rich-section-renderer"
    ];
  };
}
