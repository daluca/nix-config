{ lib, pkgs, osConfig, ... }:

{
  home.packages = with pkgs.unstable; [
    kubectl
    kubectx
    # TODO: Make fzf conditionally check if already added
    fzf
  ];

  home.shellAliases = {
    k = "kubectl";
  };

  home.persistence.home.directories = lib.mkIf osConfig.environment.persistence.system.enable [
    ".kube"
  ];
}
