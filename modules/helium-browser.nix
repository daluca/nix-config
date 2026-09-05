{ withSystem, ... }:

{
  flake.overlays.helium =
    _final: prev:
    withSystem prev.stdenv.hostPlatform.system (
      { inputs', ... }: {
        helium = inputs'.nur.legacyPackages.repos.Ev357.helium;
      }
    );

  flake.homeManagerModules.heliumBrowser = { pkgs, ... }: {
    home.packages = with pkgs; [
      helium
    ];
  };
}
