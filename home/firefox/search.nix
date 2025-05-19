{ config, pkgs, osConfig, secrets, ... }:
let
  inherit (pkgs) fetchurl fetchzip nixos-icons;
  inherit (config.home) username stateVersion;
  inherit (osConfig) system;
  inherit (secrets) kagi;
in {
  programs.firefox.profiles.${config.home.username}.search = {
    force = true;
    default = "Kagi";
    privateDefault = "Kagi";
    order = [
      "Kagi"
      "Brave"
      "Nix Packages"
      "Nix Options"
      "NixOS Wiki"
      "Noogle"
      "Home Manager Options"
      "Nixpkgs issues"
      "youtube"
      "GitHub"
      "Steam"
      "ProtonDB"
      "wikipedia"
    ];
    engines = {
      "Kagi" = {
        urls = [
          { template = "https://kagi.com/search";
            params = [
              { name = "q"; value = "{searchTerms}"; }
              { name = "token"; value = "${kagi.token}"; }
            ];
          }
          { template = "https://kagi.com/api/autosuggest";
            params = [
              { name = "q"; value = "{searchTerms}"; }
            ];
            type = "application/x-suggestions+json";
          }
        ];
        icon = fetchurl {
          url = "https://raw.githubusercontent.com/kagisearch/browser_extensions/main/shared/icons/icon_32px.png";
          hash = "sha256-pycoRxLqXsQU97veVo0M9a/KCardMetqJzcW/tjbSOc=";
        };
        definedAliases = [ "@kagi" "@k" ];
      };
      "Brave" = {
        urls = [
          { template = "https://search.brave.com/search";
            params = [
              { name = "q"; value = "{searchTerms}"; }
            ];
          }
          { template = "https://search.brave.com/api/suggest";
            params = [
              { name = "q"; value = "{searchTerms}"; }
            ];
            type = "application/x-suggestions+json";
          }
        ];
        icon = fetchurl {
          url = "https://brave.com/static-assets/images/brave-logo-sans-text.svg";
          hash = "sha256-JTD4D98hRLYvlpU6gcaYjJwxpsx8necuBpB5SFgXy+c=";
        };
        definedAliases = [ "@brave" "@b" ];
      };
      "Nix Packages" = {
        urls = [
          { template = "https://search.nixos.org/packages";
            params = [
              { name = "channel"; value = "${system.stateVersion}"; }
              { name = "type"; value = "packages"; }
              { name = "query"; value = "{searchTerms}"; }
            ];
          }
        ];
        icon = "${nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
        definedAliases = [ "@nixpackages" "@np" ];
      };
      "Nix Options" = {
        urls = [
          { template = "https://search.nixos.org/options";
            params = [
              { name = "channel"; value = "${system.stateVersion}"; }
              { name = "type"; value = "packages"; }
              { name = "query"; value = "{searchTerms}"; }
            ];
          }
        ];
        icon = "${nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
        definedAliases = [ "@nixoptions" "@no" ];
      };
      "NixOS Wiki" = {
        urls = [
          { template = "https://nixos.wiki/index.php";
            params = [
              { name = "search"; value = "{searchTerms}"; }
            ];
          }
        ];
        icon = "${nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
        definedAliases = [ "@nixoswiki" "@nw" ];
      };
      "Noogle" = {
        urls = [
          { template = "https://noogle.dev/q";
            params = [
              { name = "term"; value = "{searchTerms}"; }
            ];
          }
        ];
        icon = "${nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
        definedAliases = [ "@noogle" "@ng" ];
      };
      "Home Manager Options" = {
        urls = [
          { template = "https://home-manager-options.extranix.com/";
            params = [
              { name = "release"; value = "release-${stateVersion}"; }
              { name = "query"; value = "{searchTerms}"; }
            ];
          }
        ];
        icon = fetchurl {
          url = "https://home-manager-options.extranix.com/images/favicon.png";
          hash = "sha256-oFp+eoTLXd0GAK/VrYRUeoXntJDfTu6VnzisEt+bW74";
        };
        definedAliases = [ "@homemanageroptions" "@hmo" ];
      };
      "Nixpkgs issues" = {
        urls = [
          { template = "https://github.com/NixOS/nixpkgs/issues";
            params = [
              { name = "q"; value = "is:issue is:open {searchTerms}"; }
            ];
          }
        ];
        icon = "${nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
        definedAliases = [ "@nixpkgsissues" "@npi" ];
      };
      "YouTube" = {
        urls = [
          { template = "https://youtube.com/results";
            params = [
              { name = "search_query"; value = "{searchTerms}"; }
            ];
          }
        ];
        icon = fetchzip {
          url = "https://kstatic.googleusercontent.com/files/10450be01c1b184ffd2f49ede02f92c666f53fdf1b1cb6fa479f5e9d41cceb905e928c7be4f5593ff9edd0213a6cb096792e66ae17270b01e2cb909ee23a2955";
          hash = "sha256-pjqUtd1vq0Oou/nMlzUU46V8zDYZlA4fDQMYvBRh6M4=";
          extension = "zip";
          stripRoot = false;
        } + "/youtube_full_color_icon/digital_and_tv/yt_icon_rgb.png";
        definedAliases = [ "@youtube" "@yt" ];
      };
      "GitHub" = {
        urls = [
          { template = "https://github.com/search";
            params = [
              { name = "type"; value = "repositories"; }
              { name = "q"; value = "{searchTerms}"; }
            ];
          }
        ];
        icon = fetchurl {
          url = "https://github.com/favicon.ico";
          hash = "sha256-LuQyN9GWEAIQ8Xhue3O1fNFA9gE8Byxw29/9npvGlfg=";
        };
        definedAliases = [ "@github" ];
      };
      "Steam" = {
        urls = [
          { template = "https://store.steampowered.com/search/";
            params = [
              { name = "term"; value = "{searchTerms}"; }
            ];
          }
        ];
        icon = fetchurl {
          url = "https://store.steampowered.com/favicon.ico";
          hash = "sha256-n4kKnevN/MwzkUmnlDvpr/nkySA8L6N9VnGlssiFA60=";
        };
        definedAliases = [ "@steam" "@s" ];
      };
      "ProtonDB" = {
        urls = [
          { template = "https://www.protondb.com/search";
            params = [
              { name = "q"; value = "{searchTerms}"; }
            ];
          }
        ];
        icon = fetchurl {
          url = "https://www.protondb.com/favicon.ico";
          hash = "sha256-oauOp0EASNjMcThfzYJ2TfbaOYHBPL8LOp+9lmp4pmc=";
        };
        definedAliases = [ "@protondb" "@pdb" ];
      };
      wikipedia.metaData.alias = "@wiki";
      ebay-nl.metaData.hidden = true;
      ecosia.metaData.hidden = true;
      google.metaData.hidden = true;
      qwant.metaData.hidden = true;
      bing.metaData.hidden = true;
      ddg.metaData.hidden = true;
    };
  };
}
