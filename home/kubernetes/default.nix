{ config, lib, ... }:

{
  imports = [
    ./kubectl
    ./helm
    ./k9s
  ];

  programs.zsh.shellAliases = lib.mkIf config.programs.zsh.enable {
    headscale = "kubectl --context do-syd1-production-cluster --namespace vpn exec -it deployments/headscale -c headscale -- headscale --config=/headscale/config/config.yaml";
  };
}
