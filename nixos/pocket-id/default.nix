{
  config,
  secrets,
  ...
}:

{
  services.pocket-id = {
    enable = true;
    settings = {
      HOST = "127.0.0.1";
      PORT = 1411;
      TRUST_PROXY = true;
      ENCRYPTION_KEY_FILE = config.sops.secrets."pocket-id/encryption-key".path;
      VERSION_CHECK_DISABLED = true;
      ANALYTICS_DISABLED = true;
      DB_CONNECTION_STRING = "postgres:///${config.services.pocket-id.user}?host=/run/postgresql";
      UI_CONFIG_DISABLED = true;
      ALLOW_USER_SIGNUPS = "withToken";
      SMTP_HOST = "mail.smtp2go.com";
      SMTP_PORT = 587;
      SMTP_USER = "id.${secrets.domain.general}";
      SMTP_PASSWORD_FILE = config.sops.secrets."pocket-id/smtp-password".path;
      SMTP_FROM = "no-reply@${secrets.domain.general}";
      SMTP_TLS = "starttls";
      EMAIL_VERIFICATION_ENABLED = true;
      EMAIL_API_KEY_EXPIRATION_ENABLED = true;
      GEOLITE_DB_PATH = builtins.fetchurl {
        url = "https://github.com/P3TERX/GeoLite.mmdb/releases/download/2026.05.16/GeoLite2-City.mmdb";
        sha256 = "sha256:1vig57x7966l1y3lqls294dincms528f3sznlk1yqb06p6harw06";
      };
    };
  };

  services.postgresql = with config.services; {
    enable = true;
    ensureDatabases = [
      pocket-id.user
    ];
    ensureUsers = [
      {
        name = pocket-id.user;
        ensureDBOwnership = true;
      }
    ];
  };

  systemd.services.pocket-id = {
    requires = [ "postgresql.service" ];
    after = [ "postgresql.service" ];
  };

  sops.secrets."pocket-id/encryption-key" = with config.services; {
    owner = pocket-id.user;
    group = pocket-id.group;
  };

  sops.secrets."pocket-id/smtp-password" = with config.services; {
    owner = pocket-id.user;
    group = pocket-id.group;
  };

  systemd.tmpfiles.rules = with config.services; [
    "d ${dirOf postgresql.dataDir} 0750 postgres postgres -"
  ];

  environment.persistence.system.directories = with config.services; [
    {
      directory = pocket-id.dataDir;
      user = pocket-id.user;
      group = pocket-id.group;
      mode = "0755";
    }
    {
      directory = postgresql.dataDir;
      user = "postgres";
      group = "postgres";
      mode = "0750";
    }
  ];
}
