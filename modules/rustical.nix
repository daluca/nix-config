{
  flake.nixosModules.rustical = { config, secrets, ... }: {
    services.rustical = {
      enable = true;
      settings = {
        nextcloud_login.enabled = true;
      };
    };

    services.nginx.virtualHosts."rustical.${secrets.domain.general}" = {
      locations."/" = with config.services.rustical.settings.http; {
        proxyPass = "http://${host}:${toString port}";
      };
    };

    environment.persistence.system.directories = [
      {
        directory = "/var/lib/private/rustical";
        mode = "0700";
        defaultPerms.mode = "0700";
      }
    ];
  };
}
