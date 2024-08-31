{ pkgs ? import <nixpkgs> { }, ... }:

pkgs.mkShell {
  buildInputs = with pkgs; [
    sops
    git-agecrypt
    just
  ];
}
