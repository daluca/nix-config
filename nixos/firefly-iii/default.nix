{ config, pkgs, ... }:
let
  firefly-iii = config.services.firefly-iii;
in {
  services.firefly-iii = {
    enable = true;
    enableNginx = true;
    settings = {
      APP_KEY_FILE = config.sops.secrets."firefly-iii/app.key".path;
      APP_ENV = "production";
    };
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
}
