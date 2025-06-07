{ pkgs }:
let
  inherit (pkgs.nur.repos.rycee.firefox-addons) buildFirefoxXpiAddon;
  callPackage = pkgs.lib.callPackageWith ( pkgs // { inherit buildFirefoxXpiAddon; } );
in {
  garden-rs = callPackage ./garden-rs { };
  jsonnet-debugger = callPackage ./jsonnet-debugger { };
  tfctl = callPackage ./tfctl { };
  jellyplex-watched = callPackage ./jellyplex-watched { };
  view-secret = callPackage ./kubectl-view-secret { };
  ingress-nginx = callPackage ./kubectl-ingress-nginx { };
  bypass-paywalls-clean = callPackage ./bypass-paywalls-clean { };
  terraform = callPackage ./terraform { };
  tunarr = callPackage ./tunarr { };
}
