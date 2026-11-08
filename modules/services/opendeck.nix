{ self, inputs, ... }:

{
  flake.overlays.opendeck = _final: prev: {
    opendeck = prev.opendeck.overrideAttrs (oldAttrs: {
      postInstall = oldAttrs.postInstall + ''
        substituteInPlace $out/share/applications/opendeck.desktop \
          --replace-fail 'Exec=opendeck' 'Exec=opendeck --hide'
      '';

      env.LIBGIT2_NO_VENDOR = true;

      buildInputs =
        with prev;
        oldAttrs.buildInputs
        ++ [
          libgit2
        ];
    });
  };

  flake.nixosModules.opendeck = {
    imports = with inputs; [
      opendeck-nix.nixosModules.opendeck
    ];

    nixpkgs.overlays = with self.overlays; [
      opendeck
    ];

    programs.opendeck.enable = true;

    home-manager.users.daluca.imports = with self.homeModules; [
      opendeck
    ];
  };

  flake.homeModules.opendeck = { pkgs, ... }: {
    xdg.autostart.entries = with pkgs; [
      "${opendeck}/share/applications/opendeck.desktop"
    ];

    home.persistence.home.directories = [
      ".config/opendeck"
    ];
  };
}
