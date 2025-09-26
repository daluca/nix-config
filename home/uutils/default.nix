{ lib, pkgs, ... }:

{
  home.packages = with pkgs; [
    (lib.hiPrio uutils-coreutils-noprefix)
    (lib.hiPrio uutils-findutils)
  ];
}
