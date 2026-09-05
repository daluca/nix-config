{
  flake.overlays.anki = _final: prev: {
    ankiAddons =
      with prev.anki-utils;
      prev.ankiAddons
      // {
        more-overview-stats = buildAnkiAddon {
          pname = "more-overview-stats";
          version = "unstable-2025-02-17";
          src = prev.fetchFromGitHub {
            owner = "patrick-mahnkopf";
            repo = "anki_more_overview_stats";
            rev = "239dccd68e2cc9e845b78947f6426b47a05582ea";
            hash = "sha256-I5FjE7h2CaHzUuPFSK8DA91CJB+ngBs8ZF1UJo9gdNM=";
          };
        };
      };
  };

  flake.homeManagerModules.anki = { pkgs, ... }: {
    programs.anki = {
      enable = true;
      addons = with pkgs.ankiAddons; [
        review-heatmap
        passfail2
        more-overview-stats
      ];
    };
  };
}
