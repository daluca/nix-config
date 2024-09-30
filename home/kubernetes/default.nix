{ config, lib, ... }:

{
  imports = [
    ./kubectl
    ./helm
    ./k9s
  ];

  programs.zsh.shellAliases = lib.mkIf config.programs.zsh.enable {
    headscale = "kubectl --context do-syd1-production-cluster --namespace vpn exec -it deployments/headscale -c headscale -- headscale --config=/headscale/config/config.yaml";
    cscli = "kubectl --context do-syd1-production-cluster --namespace crowdsec exec -it deployments/crowdsec-lapi -- cscli";
    ntfy = "kubectl --context do-syd1-production-cluster --namespace ntfy exec -it statefulsets/ntfy -- ntfy";
  };
}
