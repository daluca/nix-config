{ lib, fetchFromGitLab, rustPlatform, wayland, libGL, libxkbcommon }:

rustPlatform.buildRustPackage rec {
  pname = "garden-rs";
  version = "2.3.0";

  src = fetchFromGitLab {
    owner = "garden-rs";
    repo = "garden";
    rev = "v${version}";
    hash = "sha256-9BrFcsJ2gUKva17svsjXGfUi/bBPVMG3PmtTYkN4ze8=";
  };

  cargoLock.lockFile = ./Cargo.lock;

  cargoBuildFlags = [ "--workspace" ];

  postPatch = /* bash */ ''
    ln -s ${./Cargo.lock} Cargo.lock
  '';

  postFixup = /* bash */ ''
    patchelf $out/bin/garden-gui \
      --add-rpath ${lib.makeLibraryPath [
        wayland
        libGL
        libxkbcommon
      ]}
  '';

  doCheck = false;

  meta = with lib; {
    description = "Garden grows and cultivates collections of Git trees";
    mainProgram = "garden";
    homepage = "https://gitlab.com/garden-rs/garden";
    license = licenses.mit;
  };
}
