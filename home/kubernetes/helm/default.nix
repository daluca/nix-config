{ config, lib, pkgs, ... }:

{
  home.packages = with pkgs.unstable; [
    kubernetes-helm
  ];

  programs.zsh.oh-my-zsh.plugins = lib.mkIf ( config.programs.zsh.enable && config.programs.zsh.oh-my-zsh.enable ) [
    "helm"
  ];
}
