{ pkgs, ... }:
let
  inherit (pkgs) kubectl kubectx;
in {
  imports = [
    ./plugins.nix
  ];

  home.packages = [
    kubectl
    kubectx
  ];

  home.shellAliases = {
    k = "kubectl";
  };

  home.persistence.home.directories = [
    ".kube"
  ];
}
