{ inputs }:

{
  additions = final: _prev: import ../pkgs { pkgs = final; };

  modifications =
    final: prev: with inputs; {
      intiface-central = prev.intiface-central.overrideAttrs {
        extraWrapProgramArgs = "--set FRB_DART_LOAD_EXTERNAL_LIBRARY_NATIVE_LIB_DIR $out/app/intiface-central/lib";
      };

      kubectlPlugins = with final; {
        inherit view-secret ingress-nginx;
      };
    };
}
