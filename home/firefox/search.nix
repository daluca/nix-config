{ config, pkgs, secrets, ... }@args:
let
  osConfig = (if args ? "osConfig" then args.osConfig else { system.stateVersion = config.home.stateVersion; });
in {
  force = true;
  default = "Kagi";
  privateDefault = "Kagi";
  order = [
    "Kagi"
    "Brave"
    "Nix Packages"
    "NixOS Options"
    "NixOS Wiki"
    "Noogle"
    "Home Manager Options"
    "Nixpkgs Issues"
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
      icon = pkgs.fetchurl {
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
      icon = pkgs.fetchurl {
        url = "https://brave.com/static-assets/images/brave-logo-sans-text.svg";
        hash = "sha256-JTD4D98hRLYvlpU6gcaYjJwxpsx8necuBpB5SFgXy+c=";
      };
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
    "NixOS Options" = {
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
      definedAliases = [ "@nixosoptions" "@no" ];
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
    "Noogle" = {
      urls = [
        { template = "https://noogle.dev/q";
          params = [
            { name = "term"; value = "{searchTerms}"; }
          ];
        }
      ];
      icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
      definedAliases = [ "@noogle" "@ng" ];
    };
    "Home Manager Options" = {
      urls = [
        { template = "https://home-manager-options.extranix.com/";
          params = [
            { name = "release"; value = "release-${config.home.stateVersion}"; }
            { name = "query"; value = "{searchTerms}"; }
          ];
        }
      ];
      icon = pkgs.fetchurl {
        url = "https://home-manager-options.extranix.com/images/favicon.png";
        hash = "sha256-oFp+eoTLXd0GAK/VrYRUeoXntJDfTu6VnzisEt+bW74";
      };
      definedAliases = [ "@homemanageroptions" "@hmo" ];
    };
    "Nixpkgs Issues" = {
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
    "youtube" = {
      name = "YouTube";
      urls = [
        { template = "https://youtube.com/results";
          params = [
            { name = "search_query"; value = "{searchTerms}"; }
          ];
        }
      ];
      icon = pkgs.fetchurl {
        url = "https://www.youtube.com/s/desktop/9fda8632/img/logos/favicon_144x144.png";
        hash = "sha256-453D2ML4KtI3UTKo789SHCMtXizwir65vr4a2Ur7IVc=";
      };
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
      icon = pkgs.fetchurl {
        url = "https://github.githubassets.com/favicons/favicon.svg";
        hash = "sha256-apV3zU9/prdb3hAlr4W5ROndE4g3O1XMum6fgKwurmA=";
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
      icon = pkgs.fetchurl {
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
      icon = pkgs.fetchurl {
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
}
