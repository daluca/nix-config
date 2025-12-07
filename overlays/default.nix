{ inputs }:

{
  additions = final: _prev: import ../pkgs { pkgs = final; };

  modifications = final: prev: with inputs;
  let
    inherit (final.stdenv.hostPlatform) system;
  in {
    neovim = nixvim-config.packages.${system}.neovim;

    fzf-preview = fzf-preview.packages.${system}.fzf-preview;

    nixgl = nixgl.packages.${system};

    kubectlPlugins = with final.pkgs; {
      inherit view-secret ingress-nginx;
    };

    gnomeExtensions = prev.gnomeExtensions // {
      # NOTE: Upstream tailscale-qs is not being supported anymore
      # This a work around to use the PR as the source to update to GNOME 49
      # https://github.com/joaophi/tailscale-gnome-qs/pull/45
      tailscale-qs = prev.gnomeExtensions.tailscale-qs.overrideAttrs {
        version = "20";

        src = prev.fetchFromGitHub {
          owner = "aoiwelle";
          repo = "tailscale-gnome-qs";
          rev = "fix-gnome-49";
          hash = "sha256-QQiuude//zViw6qdquOQ7fLV2F7XO8SGvU2vO1/5R5I=";
        };

        postInstall = /* bash */ ''
          mv $out/share/gnome-shell/extensions/tailscale@joaophi.github.com/tailscale@joaophi.github.com/* $out/share/gnome-shell/extensions/tailscale@joaophi.github.com/
          rmdir $out/share/gnome-shell/extensions/tailscale@joaophi.github.com/tailscale@joaophi.github.com/
        '';
      };
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
