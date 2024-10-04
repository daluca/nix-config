{ lib, buildGoModule, fetchFromGitHub }:

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
    maintainers = [ "elsesiy" ];
  };
}
