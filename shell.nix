{ pkgs ? import <nixpkgs> { }, ... }:

pkgs.mkShell {
  name = "nix-config";
  buildInputs = with pkgs; [
    sops
    git-agecrypt
    just
  ];
  JUST_COMMAND_COLOR = "blue";
}
