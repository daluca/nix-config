{ stdenv, lib, fetchurl, libva-utils, which, makeWrapper }:

stdenv.mkDerivation rec {
  pname = "tunarr";
  version = "0.21.4";

  phases = [ "unpackPhase" "installPhase" ];

  src = fetchurl {
    url = "https://github.com/chrisbenincasa/tunarr/releases/download/v${version}/tunarr-${version}-linux-x64";
    hash = "sha256-+3/utCpkITzSPNrFhknjoenIc5fpaq7bIe4+tS62l1c=";
  };

  nativeBuildInputs = [
    makeWrapper
  ];

  unpackPhase = /* bash */ ''
    cp ${src} ./tunarr-${version}-linux-x64
  '';

  installPhase = /* bash */ ''
    runHook preInstall

    install -m755 -D tunarr-${version}-linux-x64 $out/bin/tunarr

    wrapProgram $out/bin/${pname} \
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
