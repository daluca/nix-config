{ inputs }:

{
  additions = final: _prev: import ../pkgs { pkgs = final; };

  modifications = final: _prev: with inputs; {
    neovim = nixvim-config.packages.${final.system}.neovim;

    fzf-preview = fzf-preview.packages.${final.system}.fzf-preview;

    kubectlPlugins = {
      view-secret = final.pkgs.view-secret;
      ingress-nginx = final.pkgs.ingress-nginx;
    };
  };

  unstable-packages = final: _prev: with inputs; {
    unstable = import inputs.nixpkgs-unstable {
      system = final.system;
      config.allowUnfree = true;
      overlays = [(
        final: prev: {
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

          colmena = colmena.packages.${final.system}.colmena;

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
