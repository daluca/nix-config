{ pkgs, ... }:

{
  home.packages = with pkgs.unstable; [
    kubernetes-helm
  ];

  programs.zsh.oh-my-zsh.plugins = [
    "helm"
  ];
}
