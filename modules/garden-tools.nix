{ self, withSystem, ... }:

{
  perSystem = { lib, pkgs, ... }: {
    packages.garden-tools =
      with pkgs;
      rustPlatform.buildRustPackage rec {
        pname = "garden-tools";
        version = "2.7.0";

        src = fetchFromGitLab {
          owner = "garden-rs";
          repo = "garden";
          rev = "v${version}";
          hash = "sha256-yi/rEM0JfcMbOhF9KVZkk/9B4k15dvzzhKBSeMe1PgU=";
        };

        cargoHash = "sha256-dcc26c96493Ji9kfBQmFmGub1iCUzxadof9fvLNF6ts=";

        cargoBuildFlags = [ "--workspace" ];

        postFixup = /* bash */ ''
          patchelf $out/bin/garden-gui \
            --add-rpath ${
              lib.makeLibraryPath [
                wayland
                libGL
                libxkbcommon
              ]
            }
        '';

        doCheck = false;

        meta = with lib; {
          description = "Garden grows and cultivates collections of Git trees";
          mainProgram = "garden";
          homepage = "https://gitlab.com/garden-rs/garden";
          license = licenses.mit;
        };
      };
  };

  flake.overlays.garden-tools =
    _final: prev:
    withSystem prev.stdenv.hostPlatform.system (
      { self', ... }: {
        garden-tools = self'.packages.garden-tools;
      }
    );

  flake.homeManagerModules.garden-tools-options =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      cfg = config.programs.garden-tools;
    in
    with lib;
    {
      options.programs.garden-tools = {
        enable = mkEnableOption "Garden grows and cultivates collections of Git trees";

        package = mkPackageOption pkgs "garden-tools" { };

        settings = lib.mkOption {
          type = types.attrs;
          default = { };
          description = "garden-tools global config file";
        };

        enableBashIntegration = mkEnableOption "Bash Integration" // {
          default = true;
        };

        enableZshIntegration = mkEnableOption "Zsh Integration" // {
          default = true;
        };

        enableFishIntegration = mkEnableOption "Fish Integration" // {
          default = true;
        };
      };

      config = mkIf cfg.enable {
        home.packages = [ cfg.package ];

        xdg.configFile."garden/garden.yaml" = lib.mkIf (cfg.settings != { }) {
          source = (pkgs.formats.yaml { }).generate "garden.yaml" cfg.settings;
        };

        programs.bash.initExtra = mkIf cfg.enableBashIntegration ''
          if [[ :$SHELLOPTS: =~ :(vi|emacs): ]]; then
            eval "$(${cfg.package}/bin/garden completion bash)"
          fi
        '';

        programs.zsh.initContent = mkIf cfg.enableZshIntegration ''
          if [[ $options[zle] = on ]]; then
            eval "$(${cfg.package}/bin/garden completion zsh)"
          fi
        '';

        programs.fish.interactiveShellInit = mkIf cfg.enableFishIntegration ''
          ${cfg.package}/bin/garden completion fish | source
        '';
      };
    };

  flake.homeManagerModules.garden-tools = { config, ... }: {
    imports = with self.homeManagerModules; [
      garden-tools-options
    ];

    programs.garden-tools = {
      enable = true;
      settings = {
        garden.root = "${config.home.homeDirectory}/Projects";

        trees = {
          cloud = {
            url = "github:daluca/cloud";
            path = "github.com/daluca/cloud";
          };
          cloud-config = {
            url = "github:daluca/cloud-config";
            path = "github.com/daluca/cloud-config";
          };
          cv = {
            url = "github:daluca/cv";
            path = "github.com/daluca/cv";
          };
          first-bevy-game = {
            url = "github:daluca/first-bevy-game";
            path = "github.com/daluca/first-bevy-game";
          };
          helm-charts = {
            url = "github:daluca/helm-charts";
            path = "github.com/daluca/helm-charts/main";
          };
          nix-config = {
            url = "github:daluca/nix-config";
            path = "github.com/daluca/nix-config";
          };
          nixvim-config = {
            url = "github:daluca/nixvim-config";
            path = "github.com/daluca/nixvim-config";
          };
          proton-ge-overlay = {
            url = "github:daluca/proton-ge-overlay";
            path = "github.com/daluca/proton-ge-overlay";
          };
        };

        groups = {
          personal = [
            "cloud"
            "cloud-config"
            "cv"
            "first-bevy-game"
            "helm-charts"
            "nix-config"
            "nixvim-config"
            "proton-ge-overlay"
          ];
        };

        gardens = {
          all.groups = [
            "personal"
          ];
        };

        commands = {
          git = "git \"$@\"";
          status = "git status --short \"$@\"";
        };
      };
    };

    home.shellAliases = {
      g = "garden";
    };
  };
}
