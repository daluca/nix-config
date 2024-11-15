{ lib, fetchFromGitHub, rustPlatform }:

rustPlatform.buildRustPackage rec {
  pname = "commitlint-rs";
  version = "0.1.12";

  src = fetchFromGitHub {
    owner = "KeisukeYamashita";
    repo = "commitlint-rs";
    rev = "v${version}";
    hash = "sha256-xDEd3jNmqur+ULjXOReolIDiqvpT2tAHj/IbH2op5Po=";
  };

  cargoHash = "sha256-SNOy0B1QARfoueMsCjLZhJsGQy2jTSeFC/D1+R/FH4Y=";

  meta = with lib; {
    description = "Lint commit messages with conventional commit messages";
    mainProgram = "commitlint";
    homepage = "https://keisukeyamashita.github.io/commitlint-rs";
    license = licenses.asl20;
  };
}
