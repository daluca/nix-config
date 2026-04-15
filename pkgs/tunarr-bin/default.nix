{ stdenv, lib, fetchurl, libva-utils, which, makeWrapper }:

stdenv.mkDerivation rec {
  pname = "tunarr-bin";
  version = "0.22.2";

  phases = [ "installPhase" ];

  src = fetchurl {
    url = "https://github.com/chrisbenincasa/tunarr/releases/download/v${version}/tunarr-${version}-linux-x64";
    hash = "sha256-quWqnwsrWCPDRaD/DhDOuV/RcBYnFCTKrb4rjgi5XIY=";
  };

  nativeBuildInputs = [
    makeWrapper
  ];

  installPhase = /* bash */ ''
    runHook preInstall

    install -m755 -D ${src} $out/bin/tunarr

    wrapProgram $out/bin/tunarr \
      --prefix PATH : ${which}/bin \
      --prefix PATH : ${libva-utils}/bin

    runHook postInstall
  '';

  meta = with lib; {
    description = "Create a classic TV experience using your own media - IPTV backed by Plex/Jellyfin/Emby";
    homepage = "https://tunarr.com/";
    mainProgram = "tunarr";
    license = licenses.zlib;
  };
}
