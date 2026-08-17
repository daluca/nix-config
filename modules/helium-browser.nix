{ inputs, ... }:

{
  flake.overlays.helium = final: _prev: {
    helium = inputs.nur.legacyPackages.${final.stdenv.hostPlatform.system}.repos.Ev357.helium;
  };

  flake.homeManagerModules.heliumBrowser = { pkgs, ... }: {
    home.packages = with pkgs; [
      helium
    ];
  };
}
