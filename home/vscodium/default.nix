{ lib, pkgs, ... }:
let
  inherit (pkgs.unstable) vscodium;
in {
  imports = [
    ../vscode
  ];

  programs.vscode = {
    enable = true;
    package = lib.mkForce vscodium;
  };

  home.shellAliases = {
    code = "codium";
  };
}
