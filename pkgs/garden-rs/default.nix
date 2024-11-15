{ lib, fetchFromGitLab, rustPlatform }:

rustPlatform.buildRustPackage rec {
  pname = "garden-rs";
  version = "1.9.1";

  src = fetchFromGitLab {
    owner = "garden-rs";
    repo = "garden";
    rev = "v${version}";
    hash = "sha256-HRXNEsKsIHmFuah2k5eFag2WkUO8td4RNDz9zyTqmYc=";
  };

  cargoHash = "sha256-2dZ9meUYOwHATNoTTYY7sS+tkCUJJns8EKJcOUOxpXs=";

  doCheck = false;

  meta = with lib; {
    description = "Garden grows and cultivates collections of Git trees";
    mainProgram = "garden";
    homepage = "https://gitlab.com/garden-rs/garden";
    license = licenses.mit;
  };
}
