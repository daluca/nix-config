{ lib, fetchFromGitLab, rustPlatform }:

rustPlatform.buildRustPackage rec {
  pname = "garden-rs";
  version = "2.1.0";

  src = fetchFromGitLab {
    owner = "garden-rs";
    repo = "garden";
    rev = "v${version}";
    hash = "sha256-clgYWxKcnm2NTAlYh5u8/ryDV6KnH1dOavMj+Cj7FEo=";
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
