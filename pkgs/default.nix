{ pkgs }:
let
  inherit (pkgs) callPackage;
in
{
  jsonnet-debugger = callPackage ./jsonnet-debugger { };
  view-secret = callPackage ./kubectl-view-secret { };
  ingress-nginx = callPackage ./kubectl-ingress-nginx { };
}
