{
  flake.nixosModules.gatus =
    {
      config,
      lib,
      secrets,
      ...
    }:
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
            url = "https://ntfy.${secrets.domains.general}/";
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
              url = "https://firefly.${secrets.domains.general}/health";
              group = "dalaran";
              interval = "60s";
              conditions = [
                "[STATUS] == 200"
                "[RESPONSE_TIME] < 1000"
                "[BODY] == OK"
              ];
              alerts = [ { type = "ntfy"; } ];
            }
            {
              name = "Firefly III Data Importer";
              url = "https://firefly-importer.${secrets.domains.general}/health";
              group = "dalaran";
              interval = "60s";
              conditions = [
                "[STATUS] == 200"
                "[RESPONSE_TIME] < 1000"
                "[BODY] == OK"
              ];
              alerts = [ { type = "ntfy"; } ];
            }
            {
              name = "Home Assistant";
              url = "https://home-assistant.${secrets.domains.general}/manifest.json";
              group = "homeassistant";
              interval = "60s";
              conditions = [
                "[STATUS] == 200"
                "[RESPONSE_TIME] < 1000"
              ];
              alerts = [ { type = "ntfy"; } ];
            }
            {
              name = "Zigbee2MQTT";
              url = "https://zigbee2mqtt.${secrets.domains.general}/";
              group = "homeassistant";
              interval = "60s";
              conditions = [
                "[STATUS] == 200"
                "[RESPONSE_TIME] < 1000"
              ];
              alerts = [ { type = "ntfy"; } ];
            }
            {
              name = "Navidrome";
              url = "https://navidrome.${secrets.domains.general}/ping";
              group = "dalaran";
              interval = "60s";
              conditions = [
                "[STATUS] == 200"
                "[RESPONSE_TIME] < 1000"
                "[BODY] == ."
              ];
              alerts = [ { type = "ntfy"; } ];
            }
            {
              enabled = false;
              name = "Sonarr";
              url = "https://sonarr.${secrets.domains.general}/ping";
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
              url = "https://radarr.${secrets.domains.general}/ping";
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
              url = "https://prowlarr.${secrets.domains.general}/ping";
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
              url = "https://jellyfin.${secrets.domains.general}/health";
              group = "shodan";
              interval = "60s";
              conditions = [
                "[STATUS] == 200"
                "[RESPONSE_TIME] < 1000"
                "[BODY] == Healthy"
              ];
              alerts = [ { type = "ntfy"; } ];
            }
            {
              name = "Seerr";
              url = "https://request.${secrets.domains.general}/api/v1/settings/public";
              group = "shodan";
              interval = "60s";
              conditions = [
                "[STATUS] == 200"
                "[RESPONSE_TIME] < 1000"
              ];
              alerts = [ { type = "ntfy"; } ];
            }
            {
              name = "redlib";
              url = "https://redlib.${secrets.domains.general}/settings";
              group = "dalaran";
              interval = "60s";
              conditions = [
                "[STATUS] == 200"
                "[RESPONSE_TIME] < 1000"
              ];
              alerts = [ { type = "ntfy"; } ];
            }
            {
              name = "ntfy.sh";
              url = "https://ntfy.${secrets.domains.general}/v1/health";
              group = "bravo";
              interval = "60s";
              conditions = [
                "[STATUS] == 200"
                "[RESPONSE_TIME] < 1000"
                "[BODY].healthy == true"
              ];
              alerts = [ { type = "ntfy"; } ];
            }
            {
              enabled = false;
              name = "Tracearr";
              url = "https://tracearr.${secrets.domains.general}/health";
              group = "shodan";
              interval = "60s";
              conditions = [
                "[STATUS] == 200"
                "[RESPONSE_TIME] < 1000"
                "[BODY].status == ok"
                "[BODY].mode == ready"
              ];
              alerts = [ { type = "ntfy"; } ];
            }
            {
              name = "attic";
              url = "https://attic.${secrets.domains.general}/";
              group = "alfa";
              interval = "60s";
              conditions = [
                "[STATUS] == 200"
                "[RESPONSE_TIME] < 1000"
              ];
              alerts = [ { type = "ntfy"; } ];
            }
            {
              name = "atuin";
              url = "https://atuin.${secrets.domains.general}/";
              group = "bravo";
              interval = "60s";
              conditions = [
                "[STATUS] == 200"
                "[RESPONSE_TIME] < 1000"
              ];
              alerts = [ { type = "ntfy"; } ];
            }
            {
              enabled = false;
              name = "SABnzbd";
              url = "https://SABnzbd.${secrets.domains.general}/";
              group = "shodan";
              interval = "60s";
              conditions = [
                "[STATUS] == 200"
                "[RESPONSE_TIME] < 1000"
              ];
              alerts = [ { type = "ntfy"; } ];
            }
            {
              enabled = false;
              name = "qBittorrent";
              url = "https://qbittorrent.${secrets.domains.general}/";
              group = "shodan";
              interval = "60s";
              conditions = [
                "[STATUS] == 200"
                "[RESPONSE_TIME] < 1000"
              ];
              alerts = [ { type = "ntfy"; } ];
            }
            {
              name = "Jellyfin";
              url = "https://jellyfin.${secrets.domains.parents}/health";
              group = "guiltyspark";
              interval = "60s";
              conditions = [
                "[STATUS] == 200"
                "[RESPONSE_TIME] < 2000"
                "[BODY] == Healthy"
              ];
              alerts = [ { type = "ntfy"; } ];
            }
            {
              name = "Seerr";
              url = "https://request.${secrets.domains.parents}/api/v1/settings/public";
              group = "guiltyspark";
              interval = "60s";
              conditions = [
                "[STATUS] == 200"
                "[RESPONSE_TIME] < 2000"
              ];
              alerts = [ { type = "ntfy"; } ];
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
              alerts = [ { type = "ntfy"; } ];
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
              alerts = [ { type = "ntfy"; } ];
            }
          ];
        };
      };

      sops.templates."gatus.env".content = lib.generators.toKeyValue { } {
        NTFY_TOKEN = config.sops.placeholder."ntfy/token";
      };

      sops.secrets."ntfy/token" = { };
    };
}
