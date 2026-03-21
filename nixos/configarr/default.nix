{ config, lib, ... }:

{
  services.configarr = {
    enable = true;
    configFile = config.sops.templates."configarr-config.yaml".path;
  };

  sops.templates."configarr-config.yaml" =
  let
    SABnzbd = {
      name = "SABnzbd";
      type = "sabnzbd";
      enable = true;
      priority = 1;
      remove_completed_downloads = true;
      remove_failed_downloads = true;
      fields = {
        host = "127.0.0.1";
        port = 8080;
        use_ssl = false;
        url_base = "/";
        api_key = config.sops.placeholder."sabnzbd/api-key";
        username = "daluca";
        password = config.sops.placeholder."sabnzbd/password";
        tv_category = "tv";
        # recent_priority = "default";
        # older_priority = "low";
      };
    };
    qBittorrent = {
      name = "qBittorrent";
      type = "qbittorrent";
      enable = true;
      remove_completed_downloads = true;
      remove_failed_downloads = true;
      fields = {
        host = "127.0.0.1";
        port = 8081;
        use_ssl = false;
        url_base = "/";
        username = "daluca";
        password = config.sops.placeholder."qbittorrent/password";
        tv_category = "tv";
        # recent_priority = "first";
        # older_priority = "last";
      };
    };
  in {
    restartUnits = [ "configarr.service" ];
    content = with config.services; lib.generators.toYAML { } {
      localCustomFormatsPath = "${configarr.dataDir}/cfs/";
      localConfigTemplatesPath = "${configarr.dataDir}/templates/";

      whisparrEnabled = false;
      readarrEnabled = false;
      lidarrEnabled = false;

      sonarr.instance = {
        base_url = "http://127.0.0.1:8989/";
        api_key = config.sops.placeholder."sonarr/api-key";
        quality_definition.type = "series";
        include = [
          {
            template = "9d142234e45d6143785ac55f5a9e8dc9";
            source = "TRASH";
          }
        ];
        media_naming = {
          series = "default";
          season = "default";
          episodes = {
            rename = true;
            standard = "default";
            daily = "default";
          };
        };
        quality_profiles = [
          {
            name = "SD";
            reset_unmatched_scores.enabled = true;
            upgrade = {
              allowed = true;
              until_quality = "DVD";
              until_score = 10000;
              min_format_score = 1;
            };
            min_format_score = 0;
            quality_sort = "top";
            qualities = [
              { name = "DVD"; }
              {
                name = "WEB 480p";
                qualities = [
                  "WEBDL-480p"
                  "WEBRip-480p"
                ];
              }
              { name = "SDTV"; }
            ];
          }
        ];
        renameQualityProfiles = [
          {
            from = "WEB-1080p (Alternative)";
            to = "HD";
          }
        ];
        custom_formats = [
          {
            trash_ids = [
              "85c61753df5da1fb2aab6f2a47426b09"
              "9c11cd3f07101cdba90a2d81cf0e56b4"
              "e2315f990da2e2cbfc9fa5b7a6fcfe48"
              "fbcb31d8dabd2a319072b84fc0b7249c"
              "15a05bc7c1a36e2b57fd628f8977e2fc"
              "ec8fa7296b64e8cd390a1600981f3923"
              "eb3d5cc0a2be0db205fb823640db6a3c"
              "44e7c4de10ae50265753082e5dc76047"
              "218e93e5702f44a68ad9e3c6ba87d2f0"
              "e6258996055b9fbab7e9cb2f75819294"
              "58790d4e2fdcd9733aa7ae68ba2bb503"
              "d84935abd3f8556dcd51d4f27e22d0a6"
              "d0c516558625b04b363fa6c5c2c7cfd4"

              "d660701077794679fd59e8bdf4ce3a29"
              "d9e511921c8cedc7282e291b0209cdc5"
              "f67c9ca88f463a48346062e8ad07713f"
              "77a7b25585c18af08f60b1547bb9b4fb"
              "36b72f59f4ea20aad9316f475f2d9fbb"
              "89358767a60cc28783cdc3d0be9388a4"
              "7a235133c87f7da4c8cccceca7e3c7a6"
              "a880d6abc21e7c16884f3ae393f84179"
              "f6cce30f1733d5c8194222a7507909bb"
              "0ac24a2a68a9700bcb7eeca8e5cd644c"
              "81d1fbf600e2540cee87f3a23f9d3c1c"
              "d34870697c9db575f17700212167be23"
              "1656adc6d7bb2c8cca6acfb6592db421"
              "c67a75ae4a1715f2bb4d492755ba4195"
              "6eb71887a8db6e783dd398446eb0e65d"
              "da393fd4e2c0cce7c9dc2669c43e0593"
              "ae58039e1319178e6be73caab5c42166"
              "1efe8da11bfd74fbbcd4d8117ddb9213"
              "9623c5c9cac8e939c1b9aedd32f640bf"

              "47435ece6b99a0b477caf360e79ba0bb"
            ];
            assign_scores_to = [
              { name = "SD"; }
            ];
          }
        ];
        root_folders = [
          "/storage/media/tv"
        ];
        download_clients = {
          data = [
            SABnzbd
            qBittorrent
          ];
          update_password = true;
          delete_unmanaged.enabled = true;
          config = {
            enable_completed_download_handling = true;
            auto_redownload_failed = true;
            auto_redownload_failed_from_interactive_search = true;
          };
        };
        delete_unmanaged_quality_profiles.enabled = true;
        delete_unmanaged_custom_formats.enabled = true;
      };

      radarr.instance = {
        base_url = "http://127.0.0.1:7878/";
        api_key = config.sops.placeholder."radarr/api-key";
        quality_definition = "movie";
        include = [
          {
            template = "9ca12ea80aa55ef916e3751f4b874151";
            source = "TRASH";
          }
        ];
        media_naming = {
          folder = "default";
          movie = {
            rename = true;
            standard = "default";
          };
        };
        renameQualityProfiles = [
          {
            from = "Remux + WEB 1080p";
            to = "HD";
          }
        ];
        root_folders = [
          "/storage/media/movies"
        ];
        download_clients = {
          data = [
            SABnzbd
            qBittorrent
          ];
          update_password = true;
          delete_unmanaged.enabled = true;
          config = {
            enable_completed_download_handling = true;
            auto_redownload_failed = true;
            auto_redownload_failed_from_interactive_search = true;
          };
        };
        delete_unmanaged_quality_profiles.enabled = true;
        delete_unmanaged_custom_formats.enabled = true;
      };
    };
  };

  sops.secrets."sonarr/api-key" = { };

  sops.secrets."radarr/api-key" = { };

  sops.secrets."sabnzbd/api-key" = { };
  sops.secrets."sabnzbd/password" = { };

  sops.secrets."qbittorrent/password" = { };
}
