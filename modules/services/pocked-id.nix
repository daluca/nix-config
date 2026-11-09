{
  flake.nixosModules.pocket-id = { config, secrets, ... }: {
    services.pocket-id = {
      enable = true;
      settings = {
        HOST = "127.0.0.1";
        PORT = 1411;
        APP_URL = "https://id.${secrets.domains.primary}";
        TRUST_PROXY = true;
        CLOUDFLARE_LOCATION_HEADERS = true;
        TRUSTED_PLATFORM = "CF-Connecting-IP";
        ENCRYPTION_KEY_FILE = config.sops.secrets."pocket-id/encryption-key".path;
        VERSION_CHECK_DISABLED = true;
        ANALYTICS_DISABLED = true;
        UI_CONFIG_DISABLED = true;
        ALLOW_USER_SIGNUPS = "withToken";
        SMTP_HOST = "mail.smtp2go.com";
        SMTP_PORT = 587;
        SMTP_USER = "id.${secrets.domains.primary}";
        SMTP_PASSWORD_FILE = config.sops.secrets."pocket-id/smtp-password".path;
        SMTP_FROM = "no-reply@${secrets.domains.primary}";
        SMTP_TLS = "starttls";
        EMAIL_VERIFICATION_ENABLED = true;
        EMAIL_API_KEY_EXPIRATION_ENABLED = true;
      };
    };

    services.nginx.virtualHosts."id.${secrets.domains.primary}" = {
      forceSSL = true;
      useACMEHost = secrets.domains.general;
      locations."/" = {
        proxyPass = "http://127.0.0.1:${toString config.services.pocket-id.settings.PORT}/";
        extraConfig = /* nginx */ ''
          proxy_busy_buffers_size 512k;
          proxy_buffers 4 512k;
          proxy_buffer_size 256k;
        '';
      };
    };

    sops.secrets."pocket-id/encryption-key" = with config.services; {
      inherit (pocket-id) group;
      owner = pocket-id.user;
    };

    sops.secrets."pocket-id/smtp-password" = with config.services; {
      inherit (pocket-id) group;
      owner = pocket-id.user;
    };

    environment.persistence.system.directories = with config.services; [
      {
        inherit (pocket-id) user group;
        directory = pocket-id.dataDir;
        mode = "0755";
      }
    ];
  };
}
