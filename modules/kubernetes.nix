{ withSystem, ... }:

{
  flake.overlays.kubectl =
    _final: prev:
    withSystem prev.stdenv.hostPlatform.system (
      { self', ... }: {
        kubectlPlugins = with self'.packages; {
          inherit view-secret ingress-nginx;
        };
      }
    );

  flake.homeManagerModules.kubectl = { pkgs, ... }: {
    home.packages =
      with pkgs;
      with pkgs.kubectlPlugins;
      [
        kubectl
        kubectx
        view-secret
        ingress-nginx
      ];

    home.shellAliases = {
      k = "kubectl";
    };

    home.persistence.home.directories = [
      ".kube"
    ];
  };
}
