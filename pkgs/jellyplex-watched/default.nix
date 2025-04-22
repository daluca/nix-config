{ lib, gnused, python312, fetchFromGitHub }:

python312.pkgs.buildPythonApplication rec {
  pname = "jellyplex-watched";
  version = "7.0.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "luigi311";
    repo = "JellyPlex-Watched";
    rev = "v${version}";
    hash = "sha256-V45Lw0YsR7qyp9t6n7D5vWsirxKYLFYEtgGhKfpStpA=";
  };

  nativeBuildInputs = [ python312.pkgs.wrapPython ];

  build-system = with python312.pkgs; [
    setuptools
  ];

  dependencies = with python312.pkgs; [
    loguru
    packaging
    plexapi
    pydantic
    python-dotenv
    requests
  ];

  pythonRelaxDeps = true;

  postPatch = /* bash */ ''
    ${gnused}/bin/sed -i "1s|^|#!\/usr/bin/env python3\n\n|" main.py

    substituteInPlace main.py src/*.py \
      --replace "from src." "from "
  '';

  postInstall = /* bash */ ''
    install -Dm755 main.py $out/bin/jellyplex-watched
  '';

  meta = with lib; {
    description = "Sync watched status between jellyfin, plex and emby locally";
    homepage = "https://github.com/luigi311/JellyPlex-Watched";
    license = licenses.gpl3;
  };
}
