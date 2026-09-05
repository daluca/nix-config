{
  flake.overlays.itch = final: prev: {
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
  };

  flake.homeManagerModules.itch = { pkgs, ... }: {
    home.packages = with pkgs; [
      itch
    ];

    home.persistence.home.directories = [
      ".config/itch"
      ".local/share/itch"
    ];
  };
}
