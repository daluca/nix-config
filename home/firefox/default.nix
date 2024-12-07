{ config, lib, pkgs, osConfig, ... }:

{
  imports = [
    ./extensions
    ./search.nix
    ./policies.nix
  ];

  programs.firefox = {
    enable = true;
    profiles."${config.home.username}" = {
      isDefault = true;
      settings = {
        # Browser
        "browser.contentblocking.category" = "strict";
        "browser.discovery.enabled" = false;
        "browser.newtabpage.activity-stream.showSponsoredTopSites" = false;
        "browser.newtabpage.activity-stream.topSitesRows" = 3;
        "browser.uiCustomization.state" = import ./layout.nix;
        # Privacy
        "privacy.donottrackheader.enabled" = true;
        "privacy.globalprivacycontrol.enabled" = true;
        # Search
        "browser.search.suggest.enabled.private" = true;
        # Security
        "dom.security.https_only_mode" = true;
        # Sidebar
        "sidebar.revamp" = true;
        "sidebar.verticalTabs" = false;
        "sidebar.main.tools" = "history";
        "sidebar.visibility" = "hide-sidebar";
        # Sign-on
        "signon.autofillForms" = false;
        "signon.rememberSignons" = false;
        # Telemetery
        "app.shield.optoutstudies.enabled" = false;
        "datareporting.healthreport.uploadEnabled" = false;
      };
    };
  };
}
