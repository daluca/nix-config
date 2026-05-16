{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
}:

buildNpmPackage {
  pname = "nextflux";
  version = "unstable-2026-05-20";

  src = fetchFromGitHub {
    owner = "electh";
    repo = "nextflux";
    rev = "main";
    hash = "sha256-6ReEqo8ZVgote5ysXAjBEIk6IzNTLK7f2Mx+JGT0sEU=";
  };

  npmDepsHash = "sha256-yF/pSY0em/BMqUrBjjtcFgF0dtgsZWAUg6BDXAQOyZU=";

  installPhase = /* bash */ ''
    mkdir -p $out/share/html

    mv dist/* $out/share/html
  '';

  meta = with lib; {
    description = "Yet another web-based frontend for Miniflux";
    homepage = "https://github.com/electh/nextflux";
    license = licenses.unlicense;
    maintainers = [ ];
    platforms = platforms.all;
  };
}
