{ pkgs ? import <nixpkgs> { }, ... }:
let
  inherit (pkgs) callPackage;
in {
  garden = callPackage ./garden { };
  jsonnet-debugger = callPackage ./jsonnet-debugger { };
  view-secret = callPackage ./kubectl-view-secret { };
  ingress-nginx = callPackage ./kubectl-ingress-nginx { };
}
