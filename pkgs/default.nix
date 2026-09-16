{ pkgs }:
let
  inherit (pkgs) callPackage;
in
{
  jsonnet-debugger = callPackage ./jsonnet-debugger { };
  jellyplex-watched = callPackage ./jellyplex-watched { };
  view-secret = callPackage ./kubectl-view-secret { };
  ingress-nginx = callPackage ./kubectl-ingress-nginx { };
}
