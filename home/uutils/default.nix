{ pkgs, ... }:

{
  home.packages = with pkgs.unstable; [
    uutils-coreutils
  ];
}
