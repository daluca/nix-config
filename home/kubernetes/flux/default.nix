{ config, lib, pkgs, ... }:
let
  inherit (pkgs.unstable) fluxcd;
  inherit (lib) mkIf;
  zsh = config.programs.zsh;
in {
  home.packages = [ fluxcd ];

  programs.zsh.oh-my-zsh.plugins = mkIf ( zsh.enable && zsh.oh-my-zsh.enable ) [
    "fluxcd"
  ];
}
