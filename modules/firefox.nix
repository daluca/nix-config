{ inputs, withSystem, ... }:
let
  secrets = fromTOML (builtins.readFile ../secrets/secrets.toml);
in
{
  perSystem =
    { inputs', lib, ... }:
    {
      packages = with inputs'.nur.legacyPackages.repos.rycee.firefox-addons; {
        hister-extension = buildFirefoxXpiAddon rec {
          pname = "hister-extension";
          version = "0.28.0";

          addonId = "{f0bda7ce-0cda-42dc-9ea8-126b20fed280}";
          url = "https://addons.mozilla.org/firefox/downloads/file/4934117/hister-${version}.xpi";
          sha256 = "sha256-PIXN+9Mt0AsKWUU6WgFa127UsOonB5y62hrtkuSesOM=";

          meta = with lib; {
            homepage = "https://github.com/asciimoo/hister";
            description = "Your own search engine";
            license = licenses.agpl3Only;
            platforms = platforms.all;
          };
        };
      };
    };

  flake.overlays.firefox-extensions =
    _final: prev:
    withSystem prev.stdenv.hostPlatform.system (
      { self', inputs', ... }: {
        firefoxExtensions = inputs'.nur.legacyPackages.repos.rycee.firefox-addons // {
          hister = self'.packages.hister-extension;
        };
      }
    );

  flake.homeManagerModules.firefox = {
    programs.custom-firefox = {
      enable = true;
      forks = [ "firefox" ];
    };
  };

  flake.homeManagerModules.firefoxBase =
    {
      config,
      lib,
      pkgs,
      osConfig,
      ...
    }:
    let
      cfg = config.programs.custom-firefox;

      policies = {
        DisableFirefoxAccounts = true;
        DisableFirefoxStudies = true;
        DisableFormHistory = true;
        DisableMasterPasswordCreation = true;
        DisablePocket = true;
        DisableTelemetry = true;
        HttpsOnlyMode = true;
        PasswordManagerEnabled = false;
        ExtensionUpdate = false;
        ExtensionSettings = with pkgs.firefoxExtensions; {
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
          ${bypass-paywalls-clean.addonId} = {
            install_url = "file://${bypass-paywalls-clean}/share/mozilla/extensions/{ec8030f7-c20a-464f-9b0e-13a3a9e97384}/${bypass-paywalls-clean.addonId}.xpi";
            installation_mode = "force_installed";
          };
          ${libredirect.addonId} = {
            install_url = "file://${libredirect}/share/mozilla/extensions/{ec8030f7-c20a-464f-9b0e-13a3a9e97384}/${libredirect.addonId}.xpi";
            installation_mode = "force_installed";
          };
          ${hister.addonId} = {
            install_url = "file://${hister}/share/mozilla/extensions/{ec8030f7-c20a-464f-9b0e-13a3a9e97384}/${hister.addonId}.xpi";
            installation_mode = "force_installed";
          };
        };
        "3rdparty".Extensions.${pkgs.firefoxExtensions.ublock-origin.addonId}.adminSettings =
          let
            hide-youtube-short = "https://github.com/gijsdev/ublock-hide-yt-shorts/raw/refs/tags/v1.10.0/list.txt";
          in
          {
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
            userFilters =
              let
                youtube-rows = toString 5;
              in
              lib.concatStringsSep "\n" [
                "youtube.com##ytd-rich-grid-row, #contents.ytd-rich-grid-row:style(display:contents !important;)"
                "youtube.com##ytd-rich-grid-renderer, html:style(--ytd-rich-grid-items-per-row: ${youtube-rows} !important;)"
                "youtube.com##ytd-rich-grid-renderer, html:style(--ytd-rich-grid-posts-per-row: ${youtube-rows} !important;)"
                "youtube.com##ytd-browse[page-subtype=\"home\"] ytd-rich-section-renderer"
              ];
          };
      };

      profiles.default = {
        id = 0;
        isDefault = true;
        search = {
          force = true;
          default = "Hister";
          privateDefault = "Hister";
          order = [
            "Hister"
            "Kagi"
            "Brave"
            "Nix Packages"
            "NixOS Options"
            "NixOS Wiki"
            "Noogle"
            "Nix Package Versions"
            "Home Manager Options"
            "Nixpkgs Issues"
            "youtube"
            "GitHub"
            "Steam"
            "ProtonDB"
            "Docker Hub"
            "Kagi Translate"
            "wikipedia"
          ];
          engines = {
            "Hister" = {
              urls = [
                {
                  template = "https://hister.daluca.nz/";
                  params = [
                    {
                      name = "q";
                      value = "{searchTerms}";
                    }
                  ];
                }
              ];
              icon = pkgs.fetchurl {
                url = "https://raw.githubusercontent.com/asciimoo/hister/refs/heads/master/webui/ext/assets/logo.png";
                hash = "sha256-IbSU/VtlY++bmrzPbDS8esh+3HTvYb56FhgK2WxGgHY=";
              };
              definedAliases = [
                "@hister"
                "@h"
              ];
            };
            "Kagi" = {
              urls = [
                {
                  template = "https://kagi.com/search";
                  params = [
                    {
                      name = "q";
                      value = "{searchTerms}";
                    }
                    {
                      name = "token";
                      value = secrets.kagi.token;
                    }
                  ];
                }
                {
                  template = "https://kagi.com/api/autosuggest";
                  params = [
                    {
                      name = "q";
                      value = "{searchTerms}";
                    }
                  ];
                  type = "application/x-suggestions+json";
                }
              ];
              icon = pkgs.fetchurl {
                url = "https://raw.githubusercontent.com/kagisearch/browser_extensions/main/shared/icons/icon_32px.png";
                hash = "sha256-pycoRxLqXsQU97veVo0M9a/KCardMetqJzcW/tjbSOc=";
              };
              definedAliases = [
                "@kagi"
                "@k"
              ];
            };
            "Kagi Translate" = {
              urls = [
                {
                  template = "https://translate.kagi.com";
                  params = [
                    {
                      name = "from";
                      value = "auto";
                    }
                    {
                      name = "to";
                      value = "en";
                    }
                    {
                      name = "text";
                      value = "{searchTerms}";
                    }
                  ];
                }
              ];
              icon = pkgs.fetchurl {
                url = "https://translate.kagi.com/icons/favicon-96x96.png";
                hash = "sha256-1Pteqogg0MiRd1Q1XW5hWjimyLnaOLgAbj+kAkfsWEg=";
              };
              definedAliases = [
                "@kagitranslate"
                "@kt"
              ];
            };
            "Brave" = {
              urls = [
                {
                  template = "https://search.brave.com/search";
                  params = [
                    {
                      name = "q";
                      value = "{searchTerms}";
                    }
                  ];
                }
                {
                  template = "https://search.brave.com/api/suggest";
                  params = [
                    {
                      name = "q";
                      value = "{searchTerms}";
                    }
                  ];
                  type = "application/x-suggestions+json";
                }
              ];
              icon = pkgs.fetchurl {
                url = "https://brave.com/static-assets/images/brave-logo-sans-text.svg";
                hash = "sha256-JTD4D98hRLYvlpU6gcaYjJwxpsx8necuBpB5SFgXy+c=";
              };
              definedAliases = [
                "@brave"
                "@b"
              ];
            };
            "Nix Packages" = {
              urls = [
                {
                  template = "https://search.nixos.org/packages";
                  params = [
                    {
                      name = "channel";
                      value = osConfig.system.stateVersion;
                    }
                    {
                      name = "include_nixos_options";
                      value = "1";
                    }
                    {
                      name = "include_modular_service_options";
                      value = "0";
                    }
                    {
                      name = "query";
                      value = "{searchTerms}";
                    }
                  ];
                }
              ];
              icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
              definedAliases = [
                "@nixpackages"
                "@np"
              ];
            };
            "NixOS Options" = {
              urls = [
                {
                  template = "https://search.nixos.org/options";
                  params = [
                    {
                      name = "channel";
                      value = osConfig.system.stateVersion;
                    }
                    {
                      name = "include_nixos_options";
                      value = toString 1;
                    }
                    {
                      name = "include_modular_service_options";
                      value = toString 0;
                    }
                    {
                      name = "query";
                      value = "{searchTerms}";
                    }
                  ];
                }
              ];
              icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
              definedAliases = [
                "@nixosoptions"
                "@no"
              ];
            };
            "NixOS Wiki" = {
              urls = [
                {
                  template = "https://nixos.wiki/index.php";
                  params = [
                    {
                      name = "search";
                      value = "{searchTerms}";
                    }
                  ];
                }
              ];
              icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
              definedAliases = [
                "@nixoswiki"
                "@nw"
              ];
            };
            "Noogle" = {
              urls = [
                {
                  template = "https://noogle.dev/q";
                  params = [
                    {
                      name = "term";
                      value = "{searchTerms}";
                    }
                  ];
                }
              ];
              icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
              definedAliases = [
                "@noogle"
                "@ng"
              ];
            };
            "Nix Package Versions" = {
              urls = [
                {
                  template = "https://lazamar.co.uk/nix-versions";
                  params = [
                    {
                      name = "channel";
                      value = osConfig.system.stateVersion;
                    }
                    {
                      name = "package";
                      value = "{searchTerms}";
                    }
                  ];
                }
              ];
              icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
              definedAliases = [
                "@nixversions"
                "@nv"
              ];
            };
            "Home Manager Options" = {
              urls = [
                {
                  template = "https://home-manager-options.extranix.com/";
                  params = [
                    {
                      name = "release";
                      value = "release-${config.home.stateVersion}";
                    }
                    {
                      name = "query";
                      value = "{searchTerms}";
                    }
                  ];
                }
              ];
              icon = pkgs.fetchurl {
                url = "https://home-manager-options.extranix.com/images/favicon.png";
                hash = "sha256-oFp+eoTLXd0GAK/VrYRUeoXntJDfTu6VnzisEt+bW74";
              };
              definedAliases = [
                "@homemanageroptions"
                "@hmo"
              ];
            };
            "Nixpkgs Issues" = {
              urls = [
                {
                  template = "https://github.com/NixOS/nixpkgs/issues";
                  params = [
                    {
                      name = "q";
                      value = "is:issue is:open {searchTerms}";
                    }
                  ];
                }
              ];
              icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
              definedAliases = [
                "@nixpkgsissues"
                "@npi"
              ];
            };
            "youtube" = {
              name = "YouTube";
              urls = [
                {
                  template = "https://youtube.com/results";
                  params = [
                    {
                      name = "search_query";
                      value = "{searchTerms}";
                    }
                  ];
                }
              ];
              icon = pkgs.fetchurl {
                url = "https://www.youtube.com/s/desktop/9fda8632/img/logos/favicon_144x144.png";
                hash = "sha256-453D2ML4KtI3UTKo789SHCMtXizwir65vr4a2Ur7IVc=";
              };
              definedAliases = [
                "@youtube"
                "@yt"
              ];
            };
            "GitHub" = {
              urls = [
                {
                  template = "https://github.com/search";
                  params = [
                    {
                      name = "type";
                      value = "repositories";
                    }
                    {
                      name = "q";
                      value = "{searchTerms}";
                    }
                  ];
                }
              ];
              icon = pkgs.fetchurl {
                url = "https://github.githubassets.com/favicons/favicon.svg";
                hash = "sha256-apV3zU9/prdb3hAlr4W5ROndE4g3O1XMum6fgKwurmA=";
              };
              definedAliases = [ "@github" ];
            };
            "Steam" = {
              urls = [
                {
                  template = "https://store.steampowered.com/search/";
                  params = [
                    {
                      name = "term";
                      value = "{searchTerms}";
                    }
                  ];
                }
              ];
              icon = pkgs.fetchurl {
                url = "https://store.steampowered.com/favicon.ico";
                hash = "sha256-n4kKnevN/MwzkUmnlDvpr/nkySA8L6N9VnGlssiFA60=";
              };
              definedAliases = [
                "@steam"
                "@s"
              ];
            };
            "ProtonDB" = {
              urls = [
                {
                  template = "https://www.protondb.com/search";
                  params = [
                    {
                      name = "q";
                      value = "{searchTerms}";
                    }
                  ];
                }
              ];
              icon = pkgs.fetchurl {
                url = "https://www.protondb.com/favicon.ico";
                hash = "sha256-oauOp0EASNjMcThfzYJ2TfbaOYHBPL8LOp+9lmp4pmc=";
              };
              definedAliases = [
                "@protondb"
                "@pdb"
              ];
            };
            "Docker Hub" = {
              urls = [
                {
                  template = "https://hub.docker.com/search";
                  params = [
                    {
                      name = "q";
                      value = "{searchTerms}";
                    }
                  ];
                }
              ];
              icon =
                pkgs.fetchzip {
                  url = "https://www.docker.com/static/Docker-Logos.zip";
                  hash = "sha256-mvoyTHkO0PN98PznZHZrfz0cZ4eN8k1RZNo4vPppYlc=";
                  stripRoot = false;
                }
                + "/docker-logos/PNG/docker-mark-blue.png";
              definedAliases = [
                "@dockerhub"
                "@dh"
              ];
            };
            wikipedia.metaData.alias = "@wiki";
            ebay-nl.metaData.hidden = true;
            ecosia.metaData.hidden = true;
            google.metaData.hidden = true;
            qwant.metaData.hidden = true;
            bing.metaData.hidden = true;
            ddg.metaData.hidden = true;
            perplexity.hidden = true;
            "7esoorv3@alefvanoon.anonaddy.medefault".hidden = true;
          };
        };
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
              url = "https://cloud.${secrets.cloud.domain}/";
            }
            {
              name = "Miniflux";
              url = "https://feeds.${secrets.cloud.domain}/";
            }
            {
              name = "Linkwarden";
              url = "https://links.${secrets.cloud.domain}/";
            }
            {
              name = "Mealie";
              url = "https://mealie.${secrets.cloud.domain}/";
            }
            {
              name = "RSS Bridge";
              url = "https://rssbridge.${secrets.cloud.domain}/";
            }
            {
              name = "Public WiFi Login";
              url = "http://nmcheck.gnome.org/";
            }
            {
              name = "Paperless";
              url = "https://paperless.${secrets.domain.general}/";
            }
            {
              name = "Home Assistant";
              url = "https://home-assistant.${secrets.domain.general}/";
            }
            {
              name = "Zigbee2MQTT";
              url = "https://zigbee2mqtt.${secrets.domain.general}/";
            }
            {
              name = "Firefly III";
              url = "https://firefly.${secrets.domain.general}/";
            }
            {
              name = "Unifi";
              url = "https://unifi.${secrets.domain.general}/";
            }
            {
              name = "Local Content Share";
              url = "https://share.${secrets.domain.general}/";
            }
            {
              name = "Gatus";
              url = "https://gatus.${secrets.domain.general}/";
            }
          ];
        };
        settings = {
          # Arkenfox
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
        };
      };
    in
    {
      imports = with inputs; [
        zen-browser.homeModules.default
      ];

      options.programs.custom-firefox = {
        enable = lib.mkEnableOption "browser";

        default = lib.mkOption {
          type = lib.types.enum [
            "firefox"
            "librewolf"
            "floorp"
            "zen-browser"
          ];
          default = "firefox";
          description = "Set as default browser";
        };

        forks = lib.mkOption {
          type = lib.types.listOf (
            lib.types.enum [
              "firefox"
              "librewolf"
              "floorp"
              "zen-browser"
            ]
          );
          default = [ "firefox" ];
          description = "Forks of Firefox to use";
        };
      };

      config = lib.mkIf cfg.enable (
        lib.mkMerge [
          (lib.mkIf (builtins.elem "firefox" cfg.forks) {
            programs.firefox = lib.recursiveUpdate { inherit policies profiles; } {
              enable = true;
              profiles.default = {
                settings = {
                  # Browser
                  "browser.startup.page" = 1;
                  "browser.startup.homepage" = "about:home";
                  "browser.newtabpage.enabled" = true;
                  "browser.contentblocking.category" = "strict";
                  "browser.discovery.enabled" = false;
                  "browser.toolbars.bookmarks.visibility" = "never";
                  "browser.newtabpage.activity-stream.topSitesRows" = 3;
                  "browser.uiCustomization.state" = builtins.toJSON {
                    placements = {
                      widget-overflow-fixed-list = [ ];
                      unified-extensions-area = [
                        "ublock0_raymondhill_net-browser-action" # uBlock Origin
                        "addon_simplelogin-browser-action" # SimpleLogin
                        "magnolia_12_34-browser-action" # Bypass Paywalls Clean
                        "jid1-bofifl9vbdl2zq_jetpack-browser-action" # Decentraleyes
                        "_74145f27-f039-47ce-a470-a662b129930a_-browser-action" # Clear URLs
                        "_7a7a4a92-a2a0-41d1-9fd7-1e92480d612d_-browser-action" # Stylus
                        "sponsorblocker_ajay_app-browser-action" # SponsorBlock
                        "gdpr_cavi_au_dk-browser-action" # Consent-O-Matic
                      ];
                      nav-bar = [
                        "sidebar-button"
                        "back-button"
                        "forward-button"
                        "stop-reload-button"
                        "vertical-spacer"
                        "customizableui-special-spring1"
                        "urlbar-container"
                        "downloads-button"
                        "customizableui-special-spring2"
                        "jordanlinkwarden_gmail_com-browser-action" # Linkwarden
                        "fxa-toolbar-menu-button"
                        "_446900e4-71c2-419f-a6a7-df9c091e268b_-browser-action" # Bitwarden
                        "unified-extensions-button"
                        "_testpilot-containers-browser-action" # Firefox Multi-Account Containers
                        "firefox-view-button"
                        "new-tab-button"
                        "alltabs-button"
                      ];
                      toolbar-menubar = [
                        "menubar-items"
                      ];
                      TabsToolbar = [ ];
                      vertical-tabs = [
                        "tabbrowser-tabs"
                      ];
                      PersonalToolbar = [
                        "personal-bookmarks"
                      ];
                    };
                    seen = [
                      "jordanlinkwarden_gmail_com-browser-action" # Linkwarden
                      "magnolia_12_34-browser-action" # Bypass Paywalls Clean
                      "_testpilot-containers-browser-action" # Firefox Multi-Account Containers
                      "jid1-bofifl9vbdl2zq_jetpack-browser-action" # Decentraleyes
                      "ublock0_raymondhill_net-browser-action" # uBlock Origin
                      "_74145f27-f039-47ce-a470-a662b129930a_-browser-action" # Clear URLs
                      "_446900e4-71c2-419f-a6a7-df9c091e268b_-browser-action" # Bitwarden
                      "_7a7a4a92-a2a0-41d1-9fd7-1e92480d612d_-browser-action" # Stylus
                      "addon_simplelogin-browser-action" # SimpleLogin
                      "sponsorblocker_ajay_app-browser-action" # SponsorBlock
                      "developer-button"
                      "gdpr_cavi_au_dk-browser-action" # Consent-O-Matic
                    ];
                    dirtyAreaCache = [
                      "unified-extensions-area"
                      "TabsToolbar"
                      "nav-bar"
                      "vertical-tabs"
                      "toolbar-menubar"
                      "PersonalToolbar"
                    ];
                    currentVersion = 22;
                    newElementCount = 8;
                  };
                  "browser.tabs.groups.enabled" = true;
                  "browser.sessionstore.resume_from_crash" = true;
                  "browser.shell.checkDefaultBrowser" = (cfg.default == "firefox");
                  # AI
                  "browser.ml.enable" = false;
                  "browser.ml.chat.enabled" = false;
                  "browser.ml.smartAssist.enabled" = false;
                  "extensions.ml.enabled" = false;
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

            xdg.mimeApps.defaultApplicationPackages = (cfg.default == "firefox") [
              config.programs.firefox.package
            ];

            home.persistence.home.directories = [
              ".config/mozilla"
            ];

            home.sessionVariables = {
              BROWSER = lib.mkIf (cfg.default == "firefox") (lib.getExe config.programs.firefox.package);
            };
          })
          (lib.mkIf (builtins.elem "librewolf" cfg.forks) {
            programs.librewolf = lib.recursiveUpdate { inherit policies profiles; } {
              enable = true;
              profiles.default = {
                settings = {
                  # Browser
                  "browser.shell.checkDefaultBrowser" = (cfg.default == "librewolf");
                };
              };
            };

            xdg.mimeApps.defaultApplicationPackages = (cfg.default == "librewolf") [
              config.programs.librewolf.package
            ];

            home.persistence.home.directories = [
              ".config/librewolf"
            ];

            home.sessionVariables = {
              BROWSER = lib.mkIf (cfg.default == "librewolf") (lib.getExe config.programs.librewolf.package);
            };
          })
          (lib.mkIf (builtins.elem "floorp" cfg.forks) {
            programs.floorp = lib.recursiveUpdate { inherit policies profiles; } {
              enable = true;
              profiles.default = {
                settings = {
                  # Browser
                  "browser.shell.checkDefaultBrowser" = (cfg.default == "floorp");
                };
              };
            };

            xdg.mimeApps.defaultApplicationPackages = (cfg.default == "floorp") [
              config.programs.floorp.package
            ];

            home.persistence.home.directories = [
              ".floorp"
            ];

            home.sessionVariables = {
              BROWSER = lib.mkIf (cfg.default == "floorp") (lib.getExe config.programs.librewolf.package);
            };
          })
          (lib.mkIf (builtins.elem "zen-browser" cfg.forks) {
            programs.zen-browser = lib.recursiveUpdate { inherit policies profiles; } {
              enable = true;
              profiles.default = {
                settings = {
                  # Browser
                  "browser.startup.page" = 1;
                  "browser.startup.homepage" = "about:home";
                  "browser.newtabpage.enabled" = true;
                  "browser.shell.checkDefaultBrowser" = (cfg.default == "zen-browser");
                  "browser.ctrlTab.sortByRecentlyUsed" = true;
                  # Zen Browser
                  "zen.welcome-screen.seen" = true;
                  "zen.force-container-workspace" = true;
                };
              };
            };

            xdg.mimeApps.defaultApplicationPackages = lib.mkIf (cfg.default == "zen-browser") [
              config.programs.zen-browser.package
            ];

            home.persistence.home.directories = [
              ".config/zen"
            ];

            home.sessionVariables = {
              BROWSER = lib.mkIf (cfg.default == "zen-browser") (lib.getExe config.programs.zen-browser.package);
            };
          })
        ]
      );
    };
}
