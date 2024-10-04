{ pkgs ? import <nixpkgs> { }, ... }:
let
  inherit (pkgs) callPackage;
in {
  garden = callPackage ./garden { };
  kubectlPlugins = {
    view-secret = callPackage ./kubectl-view-secret { };
    ingress-nginx = callPackage ./kubectl-ingress-nginx { };
  };
}
