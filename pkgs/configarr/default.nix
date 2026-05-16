{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  nodejs,
  pnpm_10,
  pnpmConfigHook,
  fetchPnpmDeps,
  makeBinaryWrapper,
  gitMinimal,
}:
let
  pnpm = pnpm_10;
in
stdenvNoCC.mkDerivation (finalAttrs: rec {
  pname = "configarr";
  version = "1.25.0";

  src = fetchFromGitHub {
    owner = "raydak-labs";
    repo = "configarr";
    tag = "v${version}";
    hash = "sha256-KATV7B4X8M45s/BoPCQDt4GlPwLenYm0H2OpYnskwm0=";
  };

  __structuredDeps = true;
  strictDeps = true;

  nativeBuildInputs = [
    nodejs
    pnpm
    pnpmConfigHook
    makeBinaryWrapper
  ];

  pnpmDeps = fetchPnpmDeps {
    inherit (finalAttrs) pname version src;
    inherit pnpm;
    fetcherVersion = 4;
    hash = "sha256-nc2cvYMInOXWtqA/lIqGJwi6xIwAYnZabWh8F+VVhLo=";
  };

  buildPhase = ''
    runHook preBuild

    pnpm build

    runHook postBuild
  '';

  checkPhase = ''
    runHook preCheck

    pnpm test

    runHook postCheck
  '';

  installPhase = ''
    runHook preInstall

    install -Dm644 -t $out/share bundle.cjs

    makeWrapper ${lib.getExe nodejs} $out/bin/${pname} \
      --add-flags "$out/share/bundle.cjs" \
      --prefix PATH : ${
        lib.makeBinPath [
          gitMinimal
        ]
      }

    runHook postInstall
  '';

  meta = with lib; {
    description = "Sync TRaSH Guides + custom configs with Sonarr/Radarr";
    homepage = "https://github.com/raydak-labs/configarr";
    changelog = "https://github.com/raydak-labs/configarr/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license = licenses.agpl3Only;
    mainProgram = "configarr";
    platforms = platforms.all;
  };
})
