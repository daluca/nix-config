{ pkgs, ... }:
let
  inherit (pkgs) nushell;
in {
  programs.nushell = {
    enable = true;
    package = nushell;
    configFile.source = ./config.nu;
  };
}
