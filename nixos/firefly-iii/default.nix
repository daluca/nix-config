{ config, pkgs, ... }:
let
  secrets = config.sops.secrets;
  firefly-iii = config.services.firefly-iii;
  firefly-iii-data-importer = config.services.firefly-iii-data-importer;
in {
  services.firefly-iii = {
    enable = true;
    enableNginx = true;
    settings = {
      APP_KEY_FILE = secrets."firefly-iii/app.key".path;
      APP_ENV = "production";
    };
  };

  services.nginx.virtualHosts.${firefly-iii.virtualHost} = {
    forceSSL = true;
    enableACME = true;
  };

  sops.secrets."firefly-iii/app.key" = {
    owner = firefly-iii.user;
    group = firefly-iii.group;
  };

  services.firefly-iii-data-importer = {
    enable = true;
    package = pkgs.unstable.firefly-iii-data-importer;
    enableNginx = true;
    settings = rec {
      VANITY_URL = FIREFLY_III_URL;
      FIREFLY_III_URL = "https://${firefly-iii.virtualHost}";
      TRUSTED_PROXIES = "**";
      APP_ENV = "production";
      FIREFLY_III_CLIENT_ID = 2;
    };
  };

  services.nginx.virtualHosts.${firefly-iii-data-importer.virtualHost} = {
    forceSSL = true;
    enableACME = true;
  };

  environment.persistence.system.directories = [
    {
      directory = firefly-iii.dataDir;
    }
    {
      directory = firefly-iii-data-importer.dataDir;
    }
  ];
}
