{ pkgs ? import <nixpkgs> { }, ... }:
let
  inherit (pkgs) callPackage;
in {
  garden-rs = callPackage ./garden-rs { };
  jsonnet-debugger = callPackage ./jsonnet-debugger { };
  tfctl = callPackage ./tfctl { };
  view-secret = callPackage ./kubectl-view-secret { };
  ingress-nginx = callPackage ./kubectl-ingress-nginx { };
  commitlint-rs = callPackage ./commitlint-rs { };
}
