{ config, pkgs, ... }:

{
  imports = [
    ./vscode.nix
    ../k9s
    ../helm
  ];

  home.packages = with pkgs.unstable; [
    kubectl
    doctl
    kubectx
    fzf
  ];

  programs.zsh.shellAliases = {
    k = "kubectl";
  };
}
