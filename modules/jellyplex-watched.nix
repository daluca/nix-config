{ withSystem, ... }:

{
  perSystem = { lib, pkgs, ... }: {
    packages.jellyplex-watched =
      with pkgs;
      python312.pkgs.buildPythonApplication rec {
        pname = "jellyplex-watched";
        version = "8.3.0";
        pyproject = true;

        src = fetchFromGitHub {
          owner = "luigi311";
          repo = "JellyPlex-Watched";
          rev = "v${version}";
          hash = "sha256-M5QLJiBVgVvp/RoliFddgsroJDNyrcKl38hSjEhFksM=";
        };

        nativeBuildInputs = [ python312.pkgs.wrapPython ];

        build-system = with python312.pkgs; [
          setuptools
        ];

        dependencies = with python312.pkgs; [
          loguru
          packaging
          plexapi
          pydantic
          python-dotenv
          requests
        ];

        pythonRelaxDeps = true;

        postPatch = /* bash */ ''
          ${gnused}/bin/sed -i "1s|^|#!\/usr/bin/env python3\n\n|" main.py

          substituteInPlace main.py src/*.py \
            --replace "from src." "from "
        '';

        postInstall = /* bash */ ''
          install -Dm755 main.py $out/bin/jellyplex-watched
        '';

        meta = with lib; {
          description = "Sync watched status between jellyfin, plex and emby locally";
          homepage = "https://github.com/luigi311/JellyPlex-Watched";
          license = licenses.gpl3;
        };
      };
  };

  flake.overlays.jellyplex-watched =
    _final: prev:
    withSystem prev.stdenv.hostPlatform.system (
      { self', ... }: {
        inherit (self'.packages) jellyplex-watched;
      }
    );

  flake.nixosModules.jellyplex-watched-options =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      cfg = config.services.jellyplex-watched;
    in
    with lib;
    {
      options.services.jellyplex-watched = {
        enable = lib.mkEnableOption "JellyPlex-Watched";

        package = lib.mkPackageOption pkgs "jellyplex-watched" { };

        dryrun = lib.mkOption {
          type = types.bool;
          default = false;
          description = "Do not mark shows/movies as played, output to log instead.";
        };

        log-level = lib.mkOption {
          type = types.enum [
            "info"
            "debug"
          ];
          default = "info";
          description = "Log level";
        };

        interval = lib.mkOption {
          type = types.ints.u32;
          default = 3600;
          description = "How often it checks services in seconds";
        };

        mappings = lib.mkOption {
          type = types.submodule {
            options = {
              users = lib.mkOption {
                type = types.attrs;
                default = { };
                description = "Map user names in the event they are different";
              };

              libraries = lib.mkOption {
                type = types.attrs;
                default = { };
                description = "Map library names in the event they are different";
              };
            };
          };
        };

        plex = lib.mkOption {
          type = types.submodule {
            options = {
              urls = lib.mkOption {
                type = types.listOf (types.strMatching "^https?://.*$");
                default = [ "http://127.0.0.1:32400" ];
                description = "List of Plex urls";
              };

              tokens = lib.mkOption {
                type = types.listOf types.str;
                default = [ ];
                description = "Plex API tokens";
              };
            };
          };
          default = {
            urls = [ "http://127.0.0.1:32400" ];
            tokens = [ ];
          };
        };

        jellyfin = lib.mkOption {
          type = types.submodule {
            options = {
              urls = lib.mkOption {
                type = types.listOf (types.strMatching "^https?://.*$");
                default = [ "http://127.0.0.1:8096" ];
                description = "List of Jellyfin urls";
              };

              tokens = lib.mkOption {
                type = types.listOf types.str;
                default = [ ];
                description = "Jellyfin API tokens";
              };
            };
          };
          default = {
            urls = [ "http://127.0.0.1:8096" ];
            tokens = [ ];
          };
        };

        emby = lib.mkOption {
          type = types.submodule {
            options = {
              urls = lib.mkOption {
                type = types.listOf (types.strMatching "^https?://.*$");
                default = [ "http://127.0.0.1:8097" ];
                description = "List of Emby urls";
              };

              tokens = lib.mkOption {
                type = types.listOf types.str;
                default = [ ];
                description = "Emby API tokens";
              };
            };
          };
          default = {
            urls = [ "http://127.0.0.1:8097" ];
            tokens = [ ];
          };
        };
      };

      config = lib.mkIf cfg.enable {
        systemd.services.jellyplex-watched = {
          description = "Sync watched status between jellyfin, plex and emby locally";
          wants = [ "network.target" ];
          after = [ "network.target" ];
          wantedBy = [ "multi-user.target" ];

          serviceConfig = {
            Type = "exec";
            ExecStart = "${cfg.package}/bin/jellyplex-watched";
            EnvironmentFile = pkgs.writeText "jellyplex-watched-env" (
              lib.generators.toKeyValue { } {
                DRYRUN = cfg.dryrun;
                DEBUG_LEVEL = cfg.log-level;
                SLEEP_DURATION = cfg.interval;
                USER_MAPPING = builtins.toJSON cfg.mappings.users;
                LIBRARY_MAPPING = builtins.toJSON cfg.mappings.libraries;
                PLEX_BASEURL = lib.concatStringsSep ", " cfg.plex.urls;
                PLEX_TOKEN = lib.concatStringsSep ", " cfg.plex.tokens;
                JELLYFIN_BASEURL = lib.concatStringsSep ", " cfg.jellyfin.urls;
                JELLYFIN_TOKEN = lib.concatStringsSep ", " cfg.jellyfin.tokens;
                EMBY_BASEURL = lib.concatStringsSep ", " cfg.emby.urls;
                EMBY_TOKEN = lib.concatStringsSep ", " cfg.emby.tokens;
              }
            );
          };
        };
      };
    };
}
