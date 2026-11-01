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

    services.nginx.virtualHosts."${config.services.firefly-iii-data-importer.virtualHost}" = {
      locations."~ \\.php$" = {
        extraConfig = /* nginx */ ''
          # NOTE: Increase the timeout on fastcgi to prevent timeouts
          # between the data-importer and nginx when processing jobs
          # https://github.com/orgs/firefly-iii/discussions/9424#discussioncomment-13177904
          fastcgi_read_timeout 3600;
        '';
      };
    };
  };
}
