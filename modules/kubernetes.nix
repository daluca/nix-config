{ withSystem, ... }:

{
  perSystem = { lib, pkgs, ... }: {
    packages.view-secret =
      with pkgs;
      buildGoModule rec {
        pname = "kubectl-view-secret";
        version = "0.13.0";

        src = fetchFromGitHub {
          owner = "elsesiy";
          repo = "kubectl-view-secret";
          rev = "v${version}";
          hash = "sha256-mdooeKlwoPxiAHaOuhMF+Zx1l0uZ1OYMgDADI7JbYDc=";
        };

        vendorHash = "sha256-5mSS7UWfdk28oXk/ONnnjj4OMGJAtH26xGES4NGZuTc=";

        subPackages = [ "./cmd/" ];

        postInstall = /* bash */ ''
          mv $out/bin/cmd $out/bin/kubectl-view_secret
        '';

        meta = with lib; {
          description = "Kubernetes CLI plugin to decode Kubernetes secrets";
          mainProgram = "kubectl-view_secret";
          homepage = "https://github.com/elsesiy/kubectl-view-secret";
          changelog = "https://github.com/elsesiy/kubectl-view-secret/releases/tag/v${version}";
          license = licenses.mit;
        };
      };

    packages.ingress-nginx =
      with pkgs;
      buildGoModule rec {
        pname = "kubectl-ingress-nginx";
        version = "1.11.2";

        src = fetchFromGitHub {
          owner = "kubernetes";
          repo = "ingress-nginx";
          rev = "controller-v${version}";
          hash = "sha256-YwUbGOJJwwOsp3unfyE0gS73D6JTbx+c0an+gWO5U6g=";
        };

        vendorHash = "sha256-9OVolUkorGSgs8BuHu4OuCNMPhJQaqaFu/vwomszSbA=";

        env.GOWORK = "off";

        subPackages = [ "./cmd/plugin" ];

        postInstall = /* bash */ ''
          mv "$out/bin/plugin" "$out/bin/kubectl-ingress_nginx"
        '';

        meta = with lib; {
          description = "Ingress-NGINX Controller plugin for kubectl";
          mainProgram = "kubectl-ingress_nginx";
          homepage = "https://kubernetes.github.io/ingress-nginx/";
          changelog = "https://github.com/kubernetes/ingress-nginx/releases/tag/v${version}";
          license = licenses.asl20;
        };
      };
  };

  flake.overlays.kubectl =
    _final: prev:
    withSystem prev.stdenv.hostPlatform.system (
      { self', ... }: {
        kubectlPlugins = { inherit (self'.packages) view-secret ingress-nginx; };
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
