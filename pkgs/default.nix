{ pkgs ? import <nixpkgs> { }, ... }:

{
  garden = pkgs.callPackage ./garden { };
}
