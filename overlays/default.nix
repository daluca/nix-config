{ inputs }:

{
  additions = final: _prev: import ../pkgs { pkgs = final; };

  modifications = final: _prev: with inputs;
  let
    inherit (final.stdenv.hostPlatform) system;
  in {
    neovim = nixvim-config.packages.${system}.neovim;

    fzf-preview = fzf-preview.packages.${system}.fzf-preview;

    nixgl = nixgl.packages.${system};

    kubectlPlugins = with final.pkgs; {
      inherit view-secret ingress-nginx;
    };
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
        }
      )];
    };
  };
}
