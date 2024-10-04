{ lib, pkgs, osConfig, ... }:
let
  inherit (pkgs) kubectl kubectx;
in {
  imports = [
    ./plugins.nix
  ];

  home.packages = [
    kubectl
    kubectx
    # TODO: Make fzf conditionally check if already added
    # fzf
  ];

  home.shellAliases = {
    k = "kubectl";
  };

  home.persistence.home.directories = lib.mkIf osConfig.environment.persistence.system.enable [
    ".kube"
  ];
}
