{ lib, buildFirefoxXpiAddon }:

buildFirefoxXpiAddon rec {
  pname = "bypass-paywalls-clean";
  version = "4.1.8.3";

  addonId = "magnolia@12.34";
  url = "https://gitflic.ru/project/magnolia1234/bpc_uploads/blob/raw?file=bypass_paywalls_clean-${version}.xpi";
  sha256 = "sha256-OF2IyrsDahLdee3rqR0ddL2nJaP3tTAkanSzTLc0tKw=";

  meta = with lib; {
    homepage = "https://twitter.com/Magnolia1234B";
    description = "Bypass Paywalls of (custom) news sites";
    license = licenses.mit;
    platforms = platforms.all;
  };
}
