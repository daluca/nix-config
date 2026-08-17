{ self, inputs, ... }:

{
  flake.overlays.opendeck = _final: prev: {
    opendeck = prev.opendeck.overrideAttrs (oldAttrs: {
      postInstall = oldAttrs.postInstall + ''
        substituteInPlace $out/share/applications/opendeck.desktop \
          --replace-fail 'Exec=opendeck' 'Exec=opendeck --hide'
      '';
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

    home-manager.users.daluca.imports = with self.homeManagerModules; [
      opendeck
    ];
  };

  flake.homeManagerModules.opendeck = { pkgs, ... }: {
    xdg.autostart.entries = with pkgs; [
      "${opendeck}/share/applications/opendeck.desktop"
    ];

    home.persistence.home.directories = [
      ".config/opendeck"
    ];
  };
}
