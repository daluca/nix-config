{ withSystem, ... }:

{
  flake.overlays.helium =
    _final: prev:
    withSystem prev.stdenv.hostPlatform.system (
      { inputs', ... }: {
        inherit (inputs'.nur.legacyPackages.repos.Ev357) helium;
      }
    );

  flake.homeModules.heliumBrowser = { pkgs, ... }: {
    home.packages = with pkgs; [
      helium
    ];
  };
}
