{ inputs }:

{
  additions = final: _prev: import ../pkgs { pkgs = final; };

  modifications =
    final: prev: with inputs; {
      lazyssh = prev.lazyssh.overrideAttrs {
        version = "0.3.0+595f730";

        src = prev.fetchFromGitHub {
          owner = "gonsalvesc";
          repo = "lazyssh";
          rev = "XDG-base-directory";
          hash = "sha256-nNy69fFkqr8oHk86XW9XLbuSpDloqJb4dDjHE7Mfn58=";
        };

        vendorHash = "sha256-OMlpqe7FJDqgppxt4t8lJ1KnXICOh6MXVXoKkYJ74Ks=";
      };

      itch =
        let
          itch-setup = prev.fetchzip {
            url = "https://broth.itch.zone/itch-setup/linux-amd64/1.26.0/itch-setup.zip";
            stripRoot = false;
            hash = "sha256-5MP6X33Jfu97o5R1n6Og64Bv4ZMxVM0A8lXeQug+bNA=";
          };
        in
        prev.itch.overrideAttrs (oldAttrs: {
          postFixup = oldAttrs.postFixup + /* bash */ ''
            makeWrapper ${prev.steam-run}/bin/steam-run $out/bin/itch \
              --add-flags ${prev.electron}/bin/electron \
              --add-flags $out/share/itch/resources/app \
              --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform-hint=auto --enable-features=WaylandWindowDecorations --enable-wayland-ime=true}}" \
              --set BROTH_USE_LOCAL butler,itch-setup \
              --prefix PATH : ${prev.butler}/bin/:${itch-setup}:${prev.lib.getOutput "steamcompattool" final.proton-ge-bin}/files/bin
          '';
        });

      intiface-central = prev.intiface-central.overrideAttrs {
        extraWrapProgramArgs = "--set FRB_DART_LOAD_EXTERNAL_LIBRARY_NATIVE_LIB_DIR $out/app/intiface-central/lib";
      };

      kubectlPlugins = with final; {
        inherit view-secret ingress-nginx;
      };

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
}
