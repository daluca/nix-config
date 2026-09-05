{
  flake.overlays.intiface-central = _final: prev: {
    intiface-central = prev.intiface-central.overrideAttrs {
      extraWrapProgramArgs = "--set FRB_DART_LOAD_EXTERNAL_LIBRARY_NATIVE_LIB_DIR $out/app/intiface-central/lib";
    };
  };

  flake.homeManagerModules.initface-central = { pkgs, ... }: {
    home.packages = with pkgs; [
      intiface-central
    ];

    home.persistence.home.directories = [
      ".local/share/com.nonpolynomial.intiface_central"
    ];
  };
}
