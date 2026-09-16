{ pkgs }:
let
  inherit (pkgs) callPackage;
in
{
  view-secret = callPackage ./kubectl-view-secret { };
  ingress-nginx = callPackage ./kubectl-ingress-nginx { };
}
