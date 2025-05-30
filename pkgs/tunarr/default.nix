{ stdenv, fetchFromGitHub, nodejs, pnpm_9, corepack, turbo }:

stdenv.mkDerivation (finalAttrs: rec {
  pname = "tunarr";
  version = "0.19.3";

  src = fetchFromGitHub {
    owner = "chrisbenincasa";
    repo = "tunarr";
    rev = "v${version}";
    hash = "sha256-DAp8aZoiulpFSuB+AC/FKz3DwEW0+EUPTUhKjakxUwQ=";
  };

  nativeBuildInputs = [
    nodejs
    pnpm_9.configHook
    corepack
    turbo
  ];

  pnpmDeps = pnpm_9.fetchDeps {
    inherit (finalAttrs) pname version src;
    hash = "sha256-tbC582aTSlzhGyUrYSpEIbLzVy6DqyxC2E00olcgV4Q=";
  };

  buildPhase = /* bash */ ''
    runHook preBuild

    # turbo run build

    pnpm turbo bundle --filter=@tunarr/web

    pnpm turbo make-bin -- --target linux-x64

    ls -latr

    # pnpm turbo bundle --filter=@tunarr/web

    # pnpm turbo make-bin -- --target linux-x64

    runHook postBuild
  '';

  installPhase = /* bash */ ''
    runHook preInstall

    cp -r dist/ $out/

    runHook postInstall
  '';
})
