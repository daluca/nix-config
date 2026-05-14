{ config, lib, secrets, ... }:

{
  services.gatus = {
    enable = true;
    environmentFile = config.sops.templates."gatus.env".path;
    settings = {
      web.port = 8085;
      storage = {
        type = "sqlite";
        path = "/var/lib/gatus/data.db";
        caching = true;
      };
      alerting.ntfy = {
        url = "https://ntfy.${secrets.domain.general}/";
        topic = "gatus";
        default-alert = {
          description = "Failed health check";
          token = "\${NTFY_TOKEN}";
          failure-threshold = 3;
          success-threshold = 1;
          send-on-resolved = true;
        };
      };
      endpoints = [
        {
          name = "Firefly III";
          url = "https://firefly.${secrets.domain.general}/health";
          group = "dalaran";
          interval = "60s";
          conditions = [
            "[STATUS] == 200"
            "[RESPONSE_TIME] < 1000"
            "[BODY] == OK"
          ];
          alerts = [{ type = "ntfy"; }];
        }
        {
          name = "Firefly III Data Importer";
          url = "https://firefly-importer.${secrets.domain.general}/health";
          group = "dalaran";
          interval = "60s";
          conditions = [
            "[STATUS] == 200"
            "[RESPONSE_TIME] < 1000"
            "[BODY] == OK"
          ];
          alerts = [{ type = "ntfy"; }];
        }
        {
          name = "Home Assistant";
          url = "https://home-assistant.${secrets.domain.general}/manifest.json";
          group = "homeassistant";
          interval = "60s";
          conditions = [
            "[STATUS] == 200"
            "[RESPONSE_TIME] < 1000"
          ];
          alerts = [{ type = "ntfy"; }];
        }
        {
          name = "Zigbee2MQTT";
          url = "https://zigbee2mqtt.${secrets.domain.general}/";
          group = "homeassistant";
          interval = "60s";
          conditions = [
            "[STATUS] == 200"
            "[RESPONSE_TIME] < 1000"
          ];
          alerts = [{ type = "ntfy"; }];
        }
        {
          name = "Navidrome";
          url = "https://navidrome.${secrets.domain.general}/ping";
          group = "dalaran";
          interval = "60s";
          conditions = [
            "[STATUS] == 200"
            "[RESPONSE_TIME] < 1000"
            "[BODY] == ."
          ];
          alerts = [{ type = "ntfy"; }];
        }
        {
          enabled = false;
          name = "Sonarr";
          url = "https://sonarr.${secrets.domain.general}/ping";
          group = "shodan";
          interval = "60s";
          conditions = [
            "[STATUS] == 200"
            "[RESPONSE_TIME] < 1000"
            "[BODY].status == OK"
          ];
        }
        {
          enabled = false;
          name = "Radarr";
          url = "https://radarr.${secrets.domain.general}/ping";
          group = "shodan";
          interval = "60s";
          conditions = [
            "[STATUS] == 200"
            "[RESPONSE_TIME] < 1000"
            "[BODY].status == OK"
          ];
        }
        {
          enabled = false;
          name = "Prowlarr";
          url = "https://prowlarr.${secrets.domain.general}/ping";
          group = "shodan";
          interval = "60s";
          conditions = [
            "[STATUS] == 200"
            "[RESPONSE_TIME] < 1000"
            "[BODY].status == OK"
          ];
        }
        {
          name = "Jellyfin";
          url = "https://jellyfin.${secrets.domain.general}/health";
          group = "shodan";
          interval = "60s";
          conditions = [
            "[STATUS] == 200"
            "[RESPONSE_TIME] < 1000"
            "[BODY] == Healthy"
          ];
          alerts = [{ type = "ntfy"; }];
        }
        {
          name = "Seerr";
          url = "https://request.${secrets.domain.general}/api/v1/settings/public";
          group = "shodan";
          interval = "60s";
          conditions = [
            "[STATUS] == 200"
            "[RESPONSE_TIME] < 1000"
          ];
          alerts = [{ type = "ntfy"; }];
        }
        {
          name = "redlib";
          url = "https://redlib.${secrets.domain.general}/settings";
          group = "dalaran";
          interval = "60s";
          conditions = [
            "[STATUS] == 200"
            "[RESPONSE_TIME] < 1000"
          ];
          alerts = [{ type = "ntfy";  }];
        }
        {
          name = "ntfy.sh";
          url = "https://ntfy.${secrets.domain.general}/v1/health";
          group = "bravo";
          interval = "60s";
          conditions = [
            "[STATUS] == 200"
            "[RESPONSE_TIME] < 1000"
            "[BODY].healthy == true"
          ];
          alerts = [{ type = "ntfy"; }];
        }
        {
          enabled = false;
          name = "Tracearr";
          url = "https://tracearr.${secrets.domain.general}/health";
          group = "shodan";
          interval = "60s";
          conditions = [
            "[STATUS] == 200"
            "[RESPONSE_TIME] < 1000"
            "[BODY].status == ok"
            "[BODY].mode == ready"
          ];
          alerts = [{ type = "ntfy"; }];
        }
        {
          name = "attic";
          url = "https://attic.${secrets.domain.general}/";
          group = "alfa";
          interval = "60s";
          conditions = [
            "[STATUS] == 200"
            "[RESPONSE_TIME] < 1000"
          ];
          alerts = [{ type = "ntfy"; }];
        }
        {
          name = "atuin";
          url = "https://atuin.${secrets.domain.general}/";
          group = "bravo";
          interval = "60s";
          conditions = [
            "[STATUS] == 200"
            "[RESPONSE_TIME] < 1000"
          ];
          alerts = [{ type = "ntfy"; }];
        }
        {
          enabled = false;
          name = "RustFS";
          url = "https://rustfs.${secrets.domain.general}/health";
          group = "charlie";
          interval = "60s";
          conditions = [
            "[STATUS] == 200"
            "[RESPONSE_TIME] < 1000"
            "[BODY].status == ok"
            "[BODY].ready == true"
          ];
          alerts = [{ type = "ntfy"; }];
        }
        {
          enabled = false;
          name = "SABnzbd";
          url = "https://SABnzbd.${secrets.domain.general}/";
          group = "shodan";
          interval = "60s";
          conditions = [
            "[STATUS] == 200"
            "[RESPONSE_TIME] < 1000"
          ];
          alerts = [{ type = "ntfy"; }];
        }
        {
          enabled = false;
          name = "qBittorrent";
          url = "https://qbittorrent.${secrets.domain.general}/";
          group = "shodan";
          interval = "60s";
          conditions = [
            "[STATUS] == 200"
            "[RESPONSE_TIME] < 1000"
          ];
          alerts = [{ type = "ntfy"; }];
        }
        {
          name = "Jellyfin";
          url = "https://jellyfin.${secrets.parents.domain}/health";
          group = "guiltyspark";
          interval = "60s";
          conditions = [
            "[STATUS] == 200"
            "[RESPONSE_TIME] < 2000"
            "[BODY] == Healthy"
          ];
          alerts = [{ type = "ntfy"; }];
        }
        {
          name = "Seerr";
          url = "https://request.${secrets.parents.domain}/api/v1/settings/public";
          group = "guiltyspark";
          interval = "60s";
          conditions = [
            "[STATUS] == 200"
            "[RESPONSE_TIME] < 2000"
          ];
          alerts = [{ type = "ntfy"; }];
        }
        {
          name = "AdGuard Home";
          url = "http://10.1.1.10/";
          group = "stormwind";
          interval = "60s";
          conditions = [
            "[STATUS] == 200"
            "[RESPONSE_TIME] < 1000"
          ];
          alerts = [{ type = "ntfy"; }];
        }
        {
          name = "AdGuard Home";
          url = "http://10.1.1.11:3000/";
          group = "dalaran";
          interval = "60s";
          conditions = [
            "[STATUS] == 200"
            "[RESPONSE_TIME] < 1000"
          ];
          alerts = [{ type = "ntfy"; }];
        }
        {
          name = "Wedding page";
          url = "https://${secrets.domain.wedding}/health/";
          group = "bravo";
          interval = "60s";
          conditions = [
            "[STATUS] == 200"
            "[RESPONSE_TIME] < 1000"
            "[BODY] == OK"
          ];
          alerts = [{ type = "ntfy"; }];
        }
      ];
    };
  };

  sops.templates."gatus.env".content = lib.generators.toKeyValue { } {
    NTFY_TOKEN = config.sops.placeholder."ntfy/token";
  };

  sops.secrets."ntfy/token" = { };
}
