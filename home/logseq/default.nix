{ pkgs, ... }:

{
  home.packages = with pkgs.unstable; [
    logseq
  ];
}
