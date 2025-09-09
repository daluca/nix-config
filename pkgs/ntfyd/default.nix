{ lib, rustPlatform, fetchFromGitHub }:

rustPlatform.buildRustPackage rec {
  pname = "ntfyd";
  version = "dev";

  src = fetchFromGitHub {
    owner = "alemidev";
    repo = "ntfyd";
    rev = version;
    hash = "sha256-BCeCEEZNWCbnwLR4KrYhOatN1dbRsju0SAJ5ClQvzAw=";
  };

  cargoHash = "sha256-/elarKGwykm2+7MzA6fbSXWR6Dqdk2XJFkJcTejZmOU=";

  meta = with lib; {
    description = "ntfy.sh background notifications daemon";
    homepage = "https://github.com/alemidev/ntfyd";
    mainProgram = "ntfyd";
    license = licenses.mit;
  };
}
