{ config, secrets, inputs, ... }:
let
  inherit (config.home) username;
  inherit (secrets) cloud;
in {
  imports = [
    ./extensions
    ./search.nix
    ./policies.nix
  ];

  programs.firefox = {
    enable = true;
    profiles."${config.home.username}" = {
      isDefault = true;
      bookmarks = [
        {
          name = "Radio New Zealand";
          tags = [ "news" ];
          url = "https://www.rnz.co.nz/";
        }
        {
          name = "YouTube";
          tags = [ "media" ];
          keyword = "yt";
          url = "https://www.youtube.com/";
        }
        {
          name = "Nextcloud";
          url = "https://cloud.${cloud.domain}/";
        }
        {
          name = "Miniflux";
          url = "https://feeds.${cloud.domain}/";
        }
        {
          name = "Linkwarden";
          url = "https://links.${cloud.domain}/";
        }
        {
          name = "Mealie";
          url = "https://mealie.${cloud.domain}/";
        }
      ];
      settings = {
        # Browser
        "browser.contentblocking.category" = "strict";
        "browser.discovery.enabled" = false;
        "browser.toolbars.bookmarks.visibility" = "never";
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
        "sidebar.verticalTabs" = true;
        "sidebar.main.tools" = "history";
        "sidebar.visibility" = "always-show";
        # Sign-on
        "signon.autofillForms" = false;
        "signon.rememberSignons" = false;
        # Telemetery
        "app.shield.optoutstudies.enabled" = false;
        "datareporting.healthreport.uploadEnabled" = false;
        # Toolbox
        # Restore scrolling on vertical tab
        "toolkit.scrollbox.smoothScroll" = false;
      };
    };
  };
}
