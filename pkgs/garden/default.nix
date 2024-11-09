{ lib, fetchFromGitLab, rustPlatform }:

rustPlatform.buildRustPackage rec {
  pname = "garden";
  version = "1.9.0";

  src = fetchFromGitLab {
    owner = "garden-rs";
    repo = "garden";
    rev = "v${version}";
    hash = "sha256-DtYeiCKHwF7+ZhUrAC+gIy75bzebN6FmM9WsIyrCdy4=";
  };

  cargoHash = "sha256-Ao+gZHFX1gKkWarqdCKyhA1PnamkVwS+3+1Wx7lnX3k=";

  doCheck = false;

  meta = with lib; {
    description = "Garden grows and cultivates collections of Git trees";
    homepage = "https://gitlab.com/garden-rs/garden";
    license = licenses.mit;
  };
}
