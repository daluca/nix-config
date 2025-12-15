{ pkgs }:
let
  inherit (pkgs) lib;
  inherit (pkgs.firefoxExtensions) buildFirefoxXpiAddon;
  callPackage = lib.callPackageWith ( pkgs // { inherit buildFirefoxXpiAddon; } );
in {
  garden-tools = callPackage ./garden-tools { };
  jsonnet-debugger = callPackage ./jsonnet-debugger { };
  tfctl = callPackage ./tfctl { };
  jellyplex-watched = callPackage ./jellyplex-watched { };
  view-secret = callPackage ./kubectl-view-secret { };
  ingress-nginx = callPackage ./kubectl-ingress-nginx { };
  bypass-paywalls-clean = callPackage ./bypass-paywalls-clean { };
  terraform = callPackage ./terraform { };
  tunarr = callPackage ./tunarr { };
  ntfyd = callPackage ./ntfyd { };
}
