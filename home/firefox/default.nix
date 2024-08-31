{ config, lib, pkgs, osConfig, ... }:

{
  imports = [
    ./extensions
    ./search.nix
    ./policies.nix
  ];

  programs.firefox = {
    enable = true;
    package =
      if osConfig.services.pipewire.enable then
        (pkgs.wrapFirefox (pkgs.firefox-unwrapped.override { pipewireSupport = true; }) { })
      else
        pkgs.firefox;
    profiles."${config.home.username}" = {
      isDefault = true;
      settings = {
        # Browser
        "browser.contentblocking.category" = "strict";
        "browser.discovery.enabled" = false;
        "browser.newtabpage.activity-stream.showSponsoredTopSites" = false;
        "browser.newtabpage.activity-stream.topSitesRows" = 3;
        # Privacy
        "privacy.donottrackheader.enabled" = true;
        "privacy.globalprivacycontrol.enabled" = true;
        # Search
        "browser.search.suggest.enabled.private" = true;
        # Security
        "dom.security.https_only_mode" = true;
        # Sign-on
        "signon.autofillForms" = false;
        "signon.rememberSignons" = false;
        # Telemetery
        "app.shield.optoutstudies.enabled" = false;
        "datareporting.healthreport.uploadEnabled" = false;
        "toolkit.telemetry.cachedClientID" = "00000000-0000-0000-0000-000000000000";
      };
    };
  };

  home.persistence.home = lib.mkIf osConfig.environment.persistence.system.enable {
    directories = [
      ".mozilla"
    ];
  };
}
