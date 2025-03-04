{ config, secrets, inputs, ... }:
let
  inherit (config.home) username;
  inherit (secrets) cloud;
in {
  imports = [
    inputs.arkenfox.hmModules.arkenfox

    ./extensions
    ./search.nix
    ./policies.nix
  ];

  programs.firefox = {
    enable = true;
    arkenfox = {
      enable = true;
      version = "133.0";
    };
    profiles."${username}" = {
      id = 0;
      isDefault = true;
      arkenfox = {
        enable = true;
        "0100" /* STARTUP */ = {
          enable = true;
          "0102"."browser.startup.page".value = 1;
          "0103"."browser.startup.homepage".value = "about:home";
          "0104"."browser.newtabpage.enabled".value = true;
        };
        "0200" /* GEOLOCATION */ = {
          enable = true;
        };
        "0300" /* QUIETER FOX */ = {
          enable = true;
        };
        "0900" /* PASSWORDS */ = {
          enable = true;
        };
        "1700" /* REFERERS */ = {
          enable = true;
        };
        "2000" /* PLUGINS / MEDIA / WEBRTC */ = {
          enable = true;
        };
        "2400" /* DOCUMENT OBJECT MODEL */ = {
          enable = true;
        };
        "2700" /* ENHANCED TRACKING PROTECTION */ = {
          enable = true;
        };
      };
      bookmarks = [
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
      settings = {
        # Browser
        "browser.contentblocking.category" = "strict";
        "browser.discovery.enabled" = false;
        "browser.toolbars.bookmarks.visibility" = "never";
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
        # Toolbox
        "toolkit.scrollbox.smoothScroll" = false; # Restore scrolling on vertical tab
      };
    };
  };

  home.persistence.home.directories = [
    ".mozilla"
  ];
}
