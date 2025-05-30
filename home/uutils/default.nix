{ lib, pkgs, ... }:

{
  home.packages = with pkgs; [
    (lib.hiPrio uutils-coreutils-done)
    (lib.hiPrio uutils-findutils)
  ];
}
