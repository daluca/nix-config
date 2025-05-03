{ lib, buildGoModule, fetchFromGitHub, coreutils, installShellFiles }:

buildGoModule rec {
  pname = "terraform";
  version = "1.5.7";

  src = fetchFromGitHub {
    owner = "hashicorp";
    repo = "terraform";
    rev = "v${version}";
    hash = "sha256-pIhwJfa71/gW7lw/KRFBO4Q5Z5YMcTt3r9kD25k8cqM=";
  };

  vendorHash = "sha256-lQgWNMBf+ioNxzAV7tnTQSIS840XdI9fg9duuwoK+U4=";

  ldflags = [ "-s" "-w" ];

  postConfigure = ''
    # speakeasy hardcodes /bin/stty https://github.com/bgentry/speakeasy/issues/22
    substituteInPlace vendor/github.com/bgentry/speakeasy/speakeasy_unix.go \
      --replace "/bin/stty" "${coreutils}/bin/stty"
  '';

  nativeBuildInputs = [ installShellFiles ];

  postInstall = ''
    # https://github.com/posener/complete/blob/9a4745ac49b29530e07dc2581745a218b646b7a3/cmd/install/bash.go#L8
    installShellCompletion --bash --name terraform <(echo complete -C terraform terraform)
  '';

  preCheck = ''
    export HOME=$TMPDIR
    export TF_SKIP_REMOTE_TESTS=1
  '';

  subPackages = [ "." ];

  meta = with lib; {
    description = "Tool for building, changing, and versioning infrastructure";
    homepage = "https://www.terraform.io/";
    changelog = "https://github.com/hashicorp/terraform/blob/v${version}/CHANGELOG.md";
    license = licenses.mpl20;
    mainProgram = "terraform";
  };
}
