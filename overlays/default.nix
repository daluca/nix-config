{ inputs }:

{
  additions = final: _prev: import ../pkgs { pkgs = final; };

  modifications =
    final: prev: with inputs; {
      lazyssh = prev.lazyssh.overrideAttrs {
        version = "0.3.0+595f730";

        src = prev.fetchFromGitHub {
          owner = "gonsalvesc";
          repo = "lazyssh";
          rev = "XDG-base-directory";
          hash = "sha256-nNy69fFkqr8oHk86XW9XLbuSpDloqJb4dDjHE7Mfn58=";
        };

        vendorHash = "sha256-OMlpqe7FJDqgppxt4t8lJ1KnXICOh6MXVXoKkYJ74Ks=";
      };

      intiface-central = prev.intiface-central.overrideAttrs {
        extraWrapProgramArgs = "--set FRB_DART_LOAD_EXTERNAL_LIBRARY_NATIVE_LIB_DIR $out/app/intiface-central/lib";
      };

      kubectlPlugins = with final; {
        inherit view-secret ingress-nginx;
      };
    };
}
