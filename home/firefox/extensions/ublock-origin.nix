{ pkgs, ... }:
let
  inherit (pkgs.nur.repos.rycee.firefox-addons) ublock-origin;
  hide-youtube-short = "https://github.com/gijsdev/ublock-hide-yt-shorts/raw/refs/tags/v1.10.0/list.txt";
in
{
  programs.firefox.policies.ExtensionSettings."${ublock-origin.addonId}" = {
    install_url = "file://${ublock-origin}/share/mozilla/extensions/{ec8030f7-c20a-464f-9b0e-13a3a9e97384}/${ublock-origin.addonId}.xpi";
    installation_mode = "force_installed";
  };

  programs.firefox.policies."3rdparty".Extensions.${ublock-origin.addonId}.adminSettings = {
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
  };
}
