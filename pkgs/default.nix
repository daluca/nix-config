{ pkgs }:
let
  inherit (pkgs) lib;
  inherit (lib) callPackage;
in
{
  jsonnet-debugger = callPackage ./jsonnet-debugger { };
  tfctl = callPackage ./tfctl { };
  jellyplex-watched = callPackage ./jellyplex-watched { };
  view-secret = callPackage ./kubectl-view-secret { };
  ingress-nginx = callPackage ./kubectl-ingress-nginx { };
  terraform = callPackage ./terraform { };
  tunarr-bin = callPackage ./tunarr-bin { };
  ntfyd = callPackage ./ntfyd { };
  nextflux = callPackage ./nextflux { };
}
