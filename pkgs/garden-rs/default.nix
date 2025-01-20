{ lib, fetchFromGitLab, rustPlatform }:

rustPlatform.buildRustPackage rec {
  pname = "garden-rs";
  version = "1.10.1";

  src = fetchFromGitLab {
    owner = "garden-rs";
    repo = "garden";
    rev = "v${version}";
    hash = "sha256-fYdrqUs+zeyt/JwwLPRo0GgPuccue+IHBeDCwCXDCgY=";
  };

  cargoHash = "sha256-buF0YuA47IrGbZkZ4kjRYUujNP0vsUpkALwhJOqmnzg=";

  doCheck = false;

  meta = with lib; {
    description = "Garden grows and cultivates collections of Git trees";
    mainProgram = "garden";
    homepage = "https://gitlab.com/garden-rs/garden";
    license = licenses.mit;
  };
}
