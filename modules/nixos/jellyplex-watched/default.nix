{ config, lib, pkgs, ... }:
let
  cfg = config.services.jellyplex-watched;
in with lib; {
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
        tokens = [];
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
        tokens = [];
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
        tokens = [];
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
        EnvironmentFile=pkgs.writeText "jellyplex-watched-env" (lib.generators.toKeyValue {} {
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
        });
      };
    };
  };
}
