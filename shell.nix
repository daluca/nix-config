{ pkgs ? import <nixpkgs> { }, ... }:

pkgs.mkShell {
  name = "nix-config";
  buildInputs = with pkgs; [
    sops
    git-agecrypt
    just
  ];
}
