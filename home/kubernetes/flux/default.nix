{ pkgs, ... }:
let
  inherit (pkgs.unstable) fluxcd;
in {
  home.packages = [ fluxcd ];

  programs.zsh.oh-my-zsh.plugins = [
    "fluxcd"
  ];
}
