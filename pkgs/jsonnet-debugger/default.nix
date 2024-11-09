{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "jsonnet-debugger";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "grafana";
    repo = "jsonnet-debugger";
    rev = "v${version}";
    hash = "sha256-wIfOTflGmaNDrG0GrGmIsr4abeV9YY7ZO0rBnt46tnc=";
  };

  vendorHash = "sha256-oSbSslx2E9qhOHoTQ8RlNrAtYnuhiz9nZdxPVAtUfis=";

  ldflags = [
    "-X main.version=${version}"
  ];

  meta = with lib; {
    description = "Debugging client for the Jsonnet data templating language";
    homepage = "https://github.com/grafana/jsonnet-debugger";
    license = licenses.agpl3Only;
  };
}
