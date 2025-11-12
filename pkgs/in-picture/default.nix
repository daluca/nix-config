{ stdenv, fetchFromGitea, pkgs, lib }:

stdenv.mkDerivation rec {
  pname = "gnome-shell-extension-in-picture";
  version = "6";


  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "filiprund";
    repo = "in-picture";
    rev = "v${version}";
    hash = "sha256-DSzY0B071PjD0HuP2J80LKx4gW0uTdarfLsk58FBjNE=";
  };

  nativeBuildInputs = with pkgs; [
    buildPackages.glib
  ];

  buildPhase = /* bash */ ''
    runHook preBuild
    if [ -d schemas ]; then
      glib-compile-schemas --strict schemas
    fi
    runHook postBuild
  '';

  installPhase = /* bash */ ''
    runHook preInstall
    mkdir -p "$out/share/gnome-shell/extensions/${passthru.extensionUuid}"
    cp -a * "$out/share/gnome-shell/extensions/${passthru.extensionUuid}"
    runHook postInstall
  '';

  passthru = {
    extensionUuid = "in-picture@filiprund.cz";
    extensionPortalSlug = "in-picture";
  };

  meta = with lib; {
    description = ''
      Move and resize Picture-in-Picture windows according to your preferences, optionally keeping them always on top.
      A GNOME Shell extension designed for web browser PiP windows on Wayland.
      Works well with a multiple monitors setup.
    '';
    homepage = "https://codeberg.org/filiprund/in-picture";
    licenses = licenses.mit;
    platforms = platforms.linux;
  };
}
