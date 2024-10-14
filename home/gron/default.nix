{ pkgs, ... }:
let
  inherit (pkgs) gron;
in {
  home.packages = [
    gron
  ];

  home.shellAliases = {
    ungron = "gron --ungron";
  };
}
