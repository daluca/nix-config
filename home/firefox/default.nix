{ config, lib, pkgs, osConfig, secrets, ... }:

{
  programs.firefox = {
    enable = true;
    policies = import ./policies.nix // import ./extensions.nix { inherit lib pkgs; } ;
    profiles.${config.home.username} = {
      id = 0;
      isDefault = true;
      search = import ./search.nix { inherit config pkgs osConfig secrets; };
      bookmarks = import ./bookmarks.nix { inherit secrets; };
      settings = import ./arkenfox.nix // {
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
