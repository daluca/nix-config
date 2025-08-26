{
  imports = [
    ./kubectl
    ./helm
    ./k9s
    ./flux
    ./tfctl
  ];

  programs.zsh.shellAliases = {
    headscale = "kubectl --context do-syd1-production-cluster --namespace vpn exec -it deployments/headscale -c headscale -- headscale --config=/headscale/config/config.yaml";
    cscli = "kubectl --context do-syd1-production-cluster --namespace crowdsec exec -it deployments/crowdsec-lapi -- cscli";
  };
}
