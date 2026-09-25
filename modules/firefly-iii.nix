{
  flake.nixosModules.firefly-iii = { config, ... }: {
    services.firefly-iii = {
      enable = true;
      enableNginx = true;
      settings = {
        APP_KEY_FILE = config.sops.secrets."firefly-iii/app.key".path;
        APP_ENV = "production";
      };
    };

    sops.secrets."firefly-iii/app.key" = with config.services; {
      inherit (firefly-iii) group;
      owner = firefly-iii.user;
    };

    services.firefly-iii-data-importer = {
      enable = true;
      enableNginx = true;
      settings = {
        APP_ENV = "production";
        TRUSTED_PROXIES = "127.0.0.1";
      };
    };
  };
}
