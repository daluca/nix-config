{ lib, buildFirefoxXpiAddon }:

buildFirefoxXpiAddon rec {
  pname = "hister-extension";
  version = "0.28.0";

  addonId = "{f0bda7ce-0cda-42dc-9ea8-126b20fed280}";
  url = "https://addons.mozilla.org/firefox/downloads/file/4934117/hister-${version}.xpi";
  sha256 = "sha256-PIXN+9Mt0AsKWUU6WgFa127UsOonB5y62hrtkuSesOM=";

  meta = with lib; {
    homepage = "https://github.com/asciimoo/hister";
    description = "Your own search engine";
    license = licenses.agpl3Only;
    platforms = platforms.all;
  };
}
