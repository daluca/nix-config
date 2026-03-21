{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  nodejs,
  pnpm_10,
  makeBinaryWrapper,
  gitMinimal,
}:

stdenvNoCC.mkDerivation (finalAttrs: rec {
  pname = "configarr";
  version = "1.25.0";

  src = fetchFromGitHub {
    owner = "raydak-labs";
    repo = "configarr";
    tag = "v${version}";
    hash = "sha256-KATV7B4X8M45s/BoPCQDt4GlPwLenYm0H2OpYnskwm0=";
  };

  nativeBuildInputs = [
    nodejs
    pnpm_10.configHook
    makeBinaryWrapper
  ];

  pnpmDeps = pnpm_10.fetchDeps {
    inherit (finalAttrs) pname version src;
    fetcherVersion = 3;
    hash = "sha256-aBrKIw6QPL/piSw/hTMwo/Dt6FwtUbF8bKg64hDeczk=";
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
      --prefix PATH : ${lib.makeBinPath [
        gitMinimal
      ]}

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
