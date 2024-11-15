{ pkgs, ... }:
let
  inherit (pkgs.unstable) jujutsu;
in {
  programs.jujutsu = {
    enable = true;
    package = jujutsu;
  };
}
