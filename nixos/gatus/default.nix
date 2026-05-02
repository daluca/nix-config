{ secrets, ... }:

{
  services.gatus = {
    enable = true;
    settings = {
      web.port = 8085;
      storage = {
        type = "sqlite";
        path = "/var/lib/gatus/data.db";
        caching = true;
      };
      endpoints = [
        {
          name = "Firefly";
          url = "https://firefly.${secrets.domain.general}/health";
          interval = "60s";
          conditions = [
            "[STATUS] == 200"
            "[RESPONSE_TIME] < 1000"
            "[BODY] == OK"
          ];
        }
        {
          name = "Firefly importer";
          url = "https://firefly-importer.${secrets.domain.general}/health";
          interval = "60s";
          conditions = [
            "[STATUS] == 200"
            "[RESPONSE_TIME] < 1000"
            "[BODY] == OK"
          ];
        }
        {
          name = "Home Assistant";
          url = "https://home-assistant.${secrets.domain.general}/manifest.json";
          interval = "60s";
          conditions = [
            "[STATUS] == 200"
            "[RESPONSE_TIME] < 1000"
          ];
        }
        {
          name = "Navidrome";
          url = "https://navidrome.${secrets.domain.general}/ping";
          interval = "60s";
          conditions = [
            "[STATUS] == 200"
            "[RESPONSE_TIME] < 1000"
            "[BODY] == ."
          ];
        }
        # {
        #   name = "Sonarr";
        #   url = "https://sonarr.${secrets.domain.general}/ping";
        #   interval = "60s";
        #   conditions = [
        #     "[STATUS] == 200"
        #     "[RESPONSE_TIME] < 1000"
        #     "[BODY].status == OK"
        #   ];
        # }
        # {
        #   name = "Radarr";
        #   url = "https://radarr.${secrets.domain.general}/ping";
        #   interval = "60s";
        #   conditions = [
        #     "[STATUS] == 200"
        #     "[RESPONSE_TIME] < 1000"
        #     "[BODY].status == OK"
        #   ];
        # }
        # {
        #   name = "Prowlarr";
        #   url = "https://prowlarr.${secrets.domain.general}/ping";
        #   interval = "60s";
        #   conditions = [
        #     "[STATUS] == 200"
        #     "[RESPONSE_TIME] < 1000"
        #     "[BODY].status == OK"
        #   ];
        # }
        {
          name = "Jellyfin";
          url = "https://jellyfin.${secrets.domain.general}/health";
          interval = "60s";
          conditions = [
            "[STATUS] == 200"
            "[RESPONSE_TIME] < 1000"
            "[BODY] == Healthy"
          ];
        }
        {
          name = "Seerr";
          url = "https://request.${secrets.domain.general}/api/v1/settings/public";
          interval = "60s";
          conditions = [
            "[STATUS] == 200"
            "[RESPONSE_TIME] < 1000"
          ];
        }
        {
          name = "Redlib";
          url = "https://redlib.${secrets.domain.general}/settings";
          interval = "60s";
          conditions = [
            "[STATUS] == 200"
            "[RESPONSE_TIME] < 1000"
          ];
        }
      ];
    };
  };
}
