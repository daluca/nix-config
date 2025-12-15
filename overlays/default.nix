{ inputs }:

{
  additions = final: _prev: import ../pkgs { pkgs = final; };

  modifications = final: prev: with inputs;
  let
    inherit (final.stdenv.hostPlatform) system;
  in {
    neovim = nixvim-config.packages.${system}.neovim;

    fzf-preview = fzf-preview.packages.${system}.fzf-preview;

    openthread-border-router = openthread-border-router.legacyPackages.${system}.openthread-border-router;

    helium = nur.legacyPackages.${system}.repos.Ev357.helium;

    adguardhome = prev.adguardhome.overrideAttrs (oldAttrs: rec {
      version = "0.107.65";

      src = oldAttrs.src.override {
        tag = "v${version}";
        hash = "sha256-OOW77CJRR5vi5jHFOCyF/OyCXaQdTgEc8xZKPcF9vQE=";
      };

      vendorHash = "sha256-spBMVSZhiM0R5tf8dhZD+N4ucFZ9Wno9Y+BhZMdzQRM=";

      dashboard = prev.buildNpmPackage {
        inherit src version;
        pname = "adguardhome-dashboard";
        postPatch = ''
          cd client
        '';
        npmDepsHash = "sha256-s7TJvGyk05HkAOgjYmozvIQ3l2zYUhWrGRJrWdp9ZJQ=";
        npmBuildScript = "build-prod";
        postBuild = ''
          mkdir -p $out/build/
          cp -r ../build/static/ $out/build/
        '';
      };

      passthru = oldAttrs.passthru // {
        schema_version = 30;
      };
    });

    nixgl = nixgl.packages.${system};

    firefoxExtensions = with final; with inputs; nur.legacyPackages.${system}.repos.rycee.firefox-addons // {
      inherit bypass-paywalls-clean;
    };

    kubectlPlugins = with final; {
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
