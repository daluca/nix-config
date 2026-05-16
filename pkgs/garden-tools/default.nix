{
  lib,
  fetchFromGitLab,
  rustPlatform,
  wayland,
  libGL,
  libxkbcommon,
}:

rustPlatform.buildRustPackage rec {
  pname = "garden-tools";
  version = "2.6.0";

  src = fetchFromGitLab {
    owner = "garden-rs";
    repo = "garden";
    rev = "v${version}";
    hash = "sha256-jOFdYzm7IDP+0C5x//eJR7FNgJt1pzgMbTJl4ZkcL24=";
  };

  cargoLock.lockFile = ./Cargo.lock;

  cargoBuildFlags = [ "--workspace" ];

  postPatch = /* bash */ ''
    ln -s ${./Cargo.lock} Cargo.lock
  '';

  postFixup = /* bash */ ''
    patchelf $out/bin/garden-gui \
      --add-rpath ${
        lib.makeLibraryPath [
          wayland
          libGL
          libxkbcommon
        ]
      }
  '';

  doCheck = false;

  meta = with lib; {
    description = "Garden grows and cultivates collections of Git trees";
    mainProgram = "garden";
    homepage = "https://gitlab.com/garden-rs/garden";
    license = licenses.mit;
  };
}
