{ config, pkgs, osConfig, secrets, ... }:

{
  programs.firefox.profiles."${config.home.username}".search = {
    force = true;
    default = "Kagi";
    order = [ "Kagi" "Brave" "Nix Packages" "Nix Options" "NixOS Wiki" "Nixpkgs issues" "Home Manager Options" "GitHub" "Steam" "ProtonDB" "Wikipedia (en)" ];
    engines = {
      "Kagi" = {
        urls = [
          { template = "https://kagi.com/search";
            params = [
              { name = "q"; value = "{searchTerms}"; }
              { name = "token"; value = "${secrets.kagi.token}"; }
            ];
          }
          { template = "https://kagi.com/api/autosuggest";
            params = [
              { name = "q"; value = "{searchTerms}"; }
            ];
            type = "application/x-suggestions+json";
          }
        ];
        icon = "${pkgs.fetchurl {
          url = "https://raw.githubusercontent.com/kagisearch/browser_extensions/main/shared/icons/icon_32px.png";
          hash = "sha256-pycoRxLqXsQU97veVo0M9a/KCardMetqJzcW/tjbSOc=";
        }}";
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
        icon = "${pkgs.fetchurl {
          url = "https://brave.com/static-assets/images/brave-logo-sans-text.svg";
          hash = "sha256-JTD4D98hRLYvlpU6gcaYjJwxpsx8necuBpB5SFgXy+c=";
        }}";
        definedAliases = [ "@brave" "@b" ];
      };
      "Nix Packages" = {
        urls = [
          { template = "https://search.nixos.org/packages";
            params = [
              { name = "channel"; value = "${osConfig.system.stateVersion}"; }
              { name = "type"; value = "packages"; }
              { name = "query"; value = "{searchTerms}"; }
            ];
          }
        ];
        icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
        definedAliases = [ "@nixpackages" "@np" ];
      };
      "Nix Options" = {
        urls = [
          { template = "https://search.nixos.org/options";
            params = [
              { name = "channel"; value = "${osConfig.system.stateVersion}"; }
              { name = "type"; value = "packages"; }
              { name = "query"; value = "{searchTerms}"; }
            ];
          }
        ];
        icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
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
        icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
        definedAliases = [ "@nixoswiki" "@nw" ];
      };
      "Home Manager Options" = {
        urls = [
          { template = "https://home-manager-options.extranix.com/";
            params = [
              # TODO: replace with home.stateVersion when site include option
              #
              # Hardcoded previous stateVersion as a workaround
              { name = "release"; value = "24.05"; }
              { name = "query"; value = "{searchTerms}"; }
            ];
          }
        ];
        icon = "${pkgs.fetchurl {
          url = "https://home-manager-options.extranix.com/images/favicon.png";
          hash = "sha256-oFp+eoTLXd0GAK/VrYRUeoXntJDfTu6VnzisEt+bW74";
        }}";
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
        icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
        definedAliases = [ "@nixpkgsissues" "@npi" ];
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
        icon = "${pkgs.fetchurl {
          url = "https://github.com/favicon.ico";
          hash = "sha256-LuQyN9GWEAIQ8Xhue3O1fNFA9gE8Byxw29/9npvGlfg=";
        }}";
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
        icon = "${pkgs.fetchurl {
          url = "https://store.steampowered.com/favicon.ico";
          hash = "sha256-n4kKnevN/MwzkUmnlDvpr/nkySA8L6N9VnGlssiFA60=";
        }}";
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
        icon = "${pkgs.fetchurl {
          url = "https://www.protondb.com/favicon.ico";
          hash = "sha256-oauOp0EASNjMcThfzYJ2TfbaOYHBPL8LOp+9lmp4pmc=";
        }}";
        definedAliases = [ "@protondb" "@pdb" ];
      };
      "Wikipedia (en)".metaData.alias = "@wiki";
      "Google".metaData.hidden = true;
      "Bing".metaData.hidden = true;
      "DuckDuckGo".metaData.hidden = true;
    };
  };
}
