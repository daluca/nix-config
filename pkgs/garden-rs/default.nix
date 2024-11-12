{ lib, fetchFromGitLab, rustPlatform }:

rustPlatform.buildRustPackage rec {
  pname = "garden";
  version = "1.9.1";

  src = fetchFromGitLab {
    owner = "garden-rs";
    repo = "garden";
    rev = "v${version}";
    hash = "sha256-HRXNEsKsIHmFuah2k5eFag2WkUO8td4RNDz9zyTqmYc=";
  };

  cargoHash = "sha256-sDOjWiPDljNR9UCBlrQAbgiRxe9A8IBdAPbrSY23/PM=";

  doCheck = false;

  meta = with lib; {
    description = "Garden grows and cultivates collections of Git trees";
    mainProgram = "garden";
    homepage = "https://gitlab.com/garden-rs/garden";
    license = licenses.mit;
  };
}
