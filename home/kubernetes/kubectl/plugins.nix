{ pkgs, ... }:
let
  inherit (pkgs.kubectlPlugins) view-secret ingress-nginx;
in {
  home.packages = [
    view-secret
    ingress-nginx
  ];
}
