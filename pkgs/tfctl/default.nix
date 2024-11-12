{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "tfctl";
  version = "0.15.1";

  src = fetchFromGitHub {
    owner = "flux-iac";
    repo = "tofu-controller";
    rev = "v${version}";
    hash = "sha256-rA3HLO4sD8UmcebGGFxyg0zFpDHCzFHjHwMxPw8MiRU=";
  };

  vendorHash = "sha256-NhXgWuxSuurP46DBWOviFzCINJKaTb1mINRYeYcnnH8=";

  subPackages = [ "./cmd/tfctl" ];

  ldflags = [
    "-X main.BuildSHA=a5348809"
    "-X main.BuildVersion=v${version}"
  ];

  meta = with lib; {
    description = "A GitOps OpenTofu and Terraform controller for Flux";
    homepage = "https://flux-iac.github.io/tofu-controller";
    license = licenses.asl20;
  };
}
