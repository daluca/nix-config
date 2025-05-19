{ config, secrets, ... }:
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
    profiles."${username}" = {
      id = 0;
      isDefault = true;
      bookmarks = {
        force = true;
        settings = [
          {
            name = "Radio New Zealand";
            tags = [ "news" ];
            url = "https://www.rnz.co.nz/";
          }
          {
            name = "Hacker News";
            tags = [ "social" ];
            url = "https://news.ycombinator.com/";
          }
          {
            name = "YouTube";
            tags = [ "media" ];
            keyword = "yt";
            url = "https://www.youtube.com/";
          }
          {
            name = "Cricinfo";
            tags = [ "sports" ];
            keyword = "cric";
            url = "https://www.espncricinfo.com/";
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
          {
            name = "RSS Bridge";
            url = "https://rssbridge.${cloud.domain}/";
          }
          {
            name = "Public WiFi Login";
            url = "http://nmcheck.gnome.org/";
          }
        ];
      };
      settings = {
        # [Section 0100] STARTUP
        /* 0102 */ "browser.startup.page" = 0;
        /* 0103 */ "browser.startup.homepage" = "about:blank";
        /* 0104 */ "browser.newtabpage.enabled" = false;
        /* 0105 */ "browser.newtabpage.activity-stream.showSponsored" = false;
        /* 0105 */ "browser.newtabpage.activity-stream.showSponsoredTopSites" = false;
        /* 0106 */ "browser.newtabpage.activity-stream.default.sites" = false;
        # [Section 0200] GEOLOCATION
        /* 0202 */ "geo.provider.ms-windows-location" = false;
        /* 0202 */ "geo.provider.use_corelocation" = false;
        /* 0202 */ "geo.provider.use_geoclue" = false;
        # 0300 QUIETER FOX
        /* 0320 */ "extensions.getAddons.showPane" = false;
        /* 0321 */ "extensions.htmlaboutaddons.recommendations.enabled" = false;
        /* 0322 */ "browser.discovery.enabled" = false;
        /* 0323 */ "browser.shopping.experience2023.enabled" = false;
        /* 0335 */ "browser.newtabpage.activity-stream.feeds.telemetry" = false;
        /* 0335 */ "browser.newtabpage.activity-stream.telemetry" = false;
        /* 0340 */ "app.shield.optoutstudies.enabled" = false;
        /* 0341 */ "app.normandy.enabled" = false;
        /* 0341 */ "app.normandy.api_url" = "";
        /* 0350 */ "breakpad.reportURL" = "";
        /* 0350 */ "browser.tabs.crashReporting.sendReport" = false;
        /* 0350 */ "browser.crashReports.unsubmittedCheck.enabled" = false;
        /* 0351 */ "browser.crashReports.unsubmittedCheck.autoSubmit2" = false;
        /* 0360 */ "captivedetect.canonicalURL" = false;
        /* 0360 */ "network.captive-portal-service.enabled" = false;
        /* 0361 */ "network.connectivity-service.enabled" = false;
        # [Section 0900] PASSWORDS
        /* 0903 */ "signon.autofillForms" = false;
        /* 0904 */ "signon.formlessCapture.enabled" = false;
        /* 0905 */ "network.auth.subresource-http-auth-allow" = 1;
        /* 0906 */ "network.http.windows-sso.enabled" = false;
        /* 0907 */ "network.http.microsoft-entra-sso.enabled" = false;
        # [Section 0160] REFERERS
        /* 1600 */ "network.http.referer.XOriginTrimmingPolicy" = 2;
        # [Section 2000] PLUGINS / MEDIA / WEBRTC
        /* 2002 */ "media.peerconnection.ice.proxy_only_if_behind_proxy" = true;
        /* 2003 */ "media.peerconnection.ice.default_address_only" = true;
        /* 2004 */ "media.peerconnection.ice.no_host" = true;
        /* 2020 */ "media.gmp-provider.enabled" = false;
        # [Section 2400] DOCUMENT OBJECT MODEL
        /* 2402 */ "dom.disable_window_move_resize" = true;
        # [Section 2700] ENHANCED TRACKING PROTECTION
        /* 2701 */ "browser.contentblocking.category" = "strict";
        /* 2702 */ "privacy.antitracking.enableWebcompat" = false;
      } // {
        # Browser
        "browser.startup.page" = 1;
        "browser.startup.homepage" = "about:home";
        "browser.newtabpage.enabled" = true;
        "browser.contentblocking.category" = "strict";
        "browser.discovery.enabled" = false;
        "browser.toolbars.bookmarks.visibility" = "never";
        "browser.newtabpage.activity-stream.topSitesRows" = 3;
        "browser.uiCustomization.state" = import ./layout.nix;
        "browser.tabs.groups.enabled" = true;
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
        # Toolbox
        "toolkit.scrollbox.smoothScroll" = false; # Restore scrolling on vertical tab
      };
    };
  };

  home.persistence.home.directories = [
    ".mozilla"
  ];
}
