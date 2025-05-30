{ pkgs, ... }:

{
  imports = [
    ./bat.nix
    ./eza.nix
    ./fd.nix
    ./ripgrep.nix
  ];

  home.packages = with pkgs.unstable; [
    duf
    dust
    mprocs
    procs
    xh
  ];
}
