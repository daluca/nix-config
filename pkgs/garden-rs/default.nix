{ lib, fetchFromGitLab, rustPlatform }:

rustPlatform.buildRustPackage rec {
  pname = "garden-rs";
  version = "2.0.0";

  src = fetchFromGitLab {
    owner = "garden-rs";
    repo = "garden";
    rev = "v${version}";
    hash = "sha256-4cYrUD0fomlS+hatf5A965wkDjKV98QQG8dQGaLUCYs=";
  };

  cargoLock.lockFile = ./Cargo.lock;

  postPatch = /* bash */ ''
    ln -s ${./Cargo.lock} Cargo.lock
  '';

  doCheck = false;

  meta = with lib; {
    description = "Garden grows and cultivates collections of Git trees";
    mainProgram = "garden";
    homepage = "https://gitlab.com/garden-rs/garden";
    license = licenses.mit;
  };
}
