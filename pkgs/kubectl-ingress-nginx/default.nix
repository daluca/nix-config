{ lib, buildGoModule, fetchFromGitHub }:

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
}
