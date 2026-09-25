{ self, withSystem, ... }:

{
  perSystem = { lib, pkgs, ... }: {
    packages.tunarr-bin =
      with pkgs;
      stdenv.mkDerivation rec {
        pname = "tunarr-bin";
        version = "0.22.2";

        phases = [ "installPhase" ];

        src = fetchurl {
          url = "https://github.com/chrisbenincasa/tunarr/releases/download/v${version}/tunarr-${version}-linux-x64";
          hash = "sha256-quWqnwsrWCPDRaD/DhDOuV/RcBYnFCTKrb4rjgi5XIY=";
        };

        nativeBuildInputs = [
          makeWrapper
        ];

        installPhase = /* bash */ ''
          runHook preInstall

          install -m755 -D ${src} $out/bin/tunarr

          wrapProgram $out/bin/tunarr \
            --prefix PATH : ${which}/bin \
            --prefix PATH : ${libva-utils}/bin

          runHook postInstall
        '';

        meta = with lib; {
          description = "Create a classic TV experience using your own media - IPTV backed by Plex/Jellyfin/Emby";
          homepage = "https://tunarr.com/";
          mainProgram = "tunarr";
          license = licenses.zlib;
        };
      };
  };

  flake.overlays.tunarr =
    _final: prev:
    withSystem prev.stdenv.hostPlatform.system (
      { self', ... }: {
        inherit (self'.packages) tunarr-bin;
      }
    );

  flake.nixosModules.tunarr-options =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      cfg = config.services.tunarr;

      settings = pkgs.writeText "tunarr-settings.json" (
        builtins.toJSON (lib.recursiveUpdate defaultSettings cfg.settings)
      );

      defaultSettings = {
        version = 1;
        migration = {
          legacyMigration = false;
          isFreshSettings = false;
        };
        settings = {
          clientId = "00000000-0000-0000-0000-000000000000";
          hdhr = {
            autoDiscoveryEnabled = true;
            tunerCount = 2;
          };
          xmltv = {
            programmingHours = 12;
            refreshHours = 4;
            outputPath = "${cfg.dataDir}/xmltv.xml";
            enableImageCache = false;
            useShowPoster = false;
          };
          plexStream = {
            streamPath = "network";
            updatePlayStatus = false;
            pathReplace = "";
            pathReplaceWith = "";
          };
          ffmpeg = {
            configVersion = 5;
            ffmpegExecutablePath = "${pkgs.ffmpeg}/bin/ffmpeg";
            ffprobeExecutablePath = "${pkgs.ffmpeg}/bin/ffprobe";
            enableLogging = false;
            enableFileLogging = false;
            logLevel = "warning";
            languagePreferences = {
              preferences = [
                {
                  iso6391 = "en";
                  iso6392 = "eng";
                  displayName = "English";
                }
              ];
            };
            scalingAlgorithm = "bicubic";
            deinterlaceFilter = "none";
            useNewFfmpegPipeline = true;
            hlsDirectOutputFormat = "mpegts";
            enableSubtitleExtraction = false;
          };
        };
        system = {
          backup = {
            configurations = [ ];
          };
          logging = {
            logLevel = "info";
            logsDirectory = "/home/daluca/.local/share/tunarr/logs";
            useEnvVarLevel = true;
          };
          cache = {
            enablePlexRequestCache = false;
          };
          server = { inherit (cfg) port; };
        };
      };
    in
    with lib;
    {
      options.services.tunarr = {
        enable = lib.mkEnableOption "Tunarr";

        package = lib.mkPackageOption pkgs "tunarr-bin" { };

        port = lib.mkOption {
          type = types.port;
          default = 8000;
          description = "WebUI port for Tunarr";
        };

        dataDir = lib.mkOption {
          type = types.str;
          default = "/var/lib/tunarr";
          description = "Appdata location for database and settings files";
        };

        settings = lib.mkOption {
          type = types.attrs;
          default = { };
          description = "Tunarr settings file";
        };
      };

      config = lib.mkIf cfg.enable {
        systemd.services.tunarr = {
          description = "Create a classic TV experience using your own media - IPTV backed by Plex/Jellyfin/Emby";
          wants = [ "network.target" ];
          after = [ "network.target" ];
          wantedBy = [ "multi-user.target" ];

          serviceConfig = {
            Type = "simple";
            ExecStartPre =
              let
                preStartScript = pkgs.writeScript "tunarr-pre-start" /* bash */ ''
                  #!${pkgs.bash}/bin/bash

                  # Create data directory if it doesn't exist
                  if ! test -d ${cfg.dataDir}; then
                    echo "Creating initial Tunarr data directory in: ${cfg.dataDir}"
                    mkdir -pv ${cfg.dataDir}
                  fi

                  cp ${settings} ${cfg.dataDir}/settings.json
                '';
              in
              "!${preStartScript}";
            ExecStart = "${lib.getExe cfg.package} server --database ${cfg.dataDir} --port ${toString cfg.port}";
          };
        };
      };
    };

  flake.nixosModules.tunarr =
    let
      days = 24;
    in
    {
      imports = with self.nixosModules; [
        tunarr-options
      ];
      services.tunarr = {
        enable = true;
        port = 8108;
        settings = {
          settings.xmltv.programmingHours = 7 * days;
        };
      };
    };
}
