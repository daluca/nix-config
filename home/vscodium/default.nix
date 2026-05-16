{ lib, pkgs, ... }:

{
  imports = [
    ../vscode
  ];

  programs.vscode = {
    enable = true;
    package = lib.mkForce pkgs.unstable.vscodium;
  };

  home.shellAliases = {
    code = "codium";
  };
}
