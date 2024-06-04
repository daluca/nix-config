{ config, pkgs, ... }:

{
  home.packages = with pkgs.unstable; [
    kubectl
    doctl
    kubectx
  ];

  programs.zsh.shellAliases = {
    k = "kubectl";
  };

  imports = [ ../k9s ];
}
