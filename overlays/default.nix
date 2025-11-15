{ inputs, outputs }:

{
  additions = final: _prev: import ../pkgs { pkgs = final; };

  modifications = final: _prev: with inputs;
  let
    inherit (final.stdenv.hostPlatform) system;
  in {
    neovim = nixvim-config.packages.${system}.neovim;

    fzf-preview = fzf-preview.packages.${system}.fzf-preview;

    openthread-border-router = openthread-border-router.legacyPackages.${system}.openthread-border-router;

    kubectlPlugins = with final.pkgs; {
      inherit view-secret ingress-nginx;
    };
  };

  gnomeExtensions = final: prev:
  let
    inherit (final.stdenv.hostPlatform) system;
  in {
    gnomeExtensions = with outputs; prev.gnomeExtensions // {
      in-picture = packages.${system}.in-picture;
    };
  };

  python3 = _final: prev: {
    pythonPackagesExtensions = prev.pythonPackagesExtensions ++ [(
      _pythonFinal: pythonPrev: {
        cfn-lint = pythonPrev.cfn-lint.overridePythonAttrs {
          doCheck = false;
        };
        # NOTE: Remove after https://github.com/NixOS/nixpkgs/issues/460422 has been resolved
        ansible-compat = pythonPrev.ansible-compat.overridePythonAttrs rec {
          version = "25.8.1";

          src = prev.fetchFromGitHub {
            owner = "ansible";
            repo = "ansible-compat";
            tag = "v${version}";
            hash = "sha256-hwfD7B0r8wRo/BUUA00TTQXCkrY8TAUM5BiP4Q4Atd0=";
          };
        };
      }
    )];
  };

  unstable-packages = final: _prev: with inputs;
  let
    inherit (final.stdenv.hostPlatform) system;
  in {
    unstable = import inputs.nixpkgs-unstable {
      inherit system;
      config.allowUnfree = true;
      overlays = [(
        final: prev:
        let
          inherit (final.stdenv.hostPlatform) system;
        in {
          deploy-rs = prev.deploy-rs.overrideAttrs {
            version = "0.1.0-unstable-2025-09-01";

            src = prev.fetchFromGitHub {
              owner = "serokell";
              repo = "deploy-rs";
              rev = "125ae9e3ecf62fb2c0fd4f2d894eb971f1ecaed2";
              hash = "sha256-N9gBKUmjwRKPxAafXEk1EGadfk2qDZPBQp4vXWPHINQ=";
            };

            postPatch = /* bash */ ''
              substituteInPlace src/cli.rs \
                --replace 'version = "1.0"' 'version = "0.1.0"'
            '';
          };

          colmena = colmena.packages.${system}.colmena;

          paperless-ngx = prev.paperless-ngx.overrideAttrs (oldAttrs: {
            passthru = oldAttrs.passthru // {
              nltkData = with prev.nltk-data; [
                punkt-tab
                snowball-data
                stopwords
              ];
            };
          });

          pythonPackagesExtensions = prev.pythonPackagesExtensions ++ [(
            _pythonFinal: pythonPrev: {
              img2pdf = pythonPrev.img2pdf.overridePythonAttrs {
                doCheck = false;
              };
            }
          )];
        }
      )];
    };
  };
}
