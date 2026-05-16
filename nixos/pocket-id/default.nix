{
  config,
  pkgs,
  secrets,
  inputs,
  ...
}:

{
  disabledModules = [
    "services/security/pocket-id.nix"
  ];

  imports = [
    (inputs.nixpkgs-unstable + "/nixos/modules/services/security/pocket-id.nix")
  ];

  services.pocket-id = {
    enable = true;
    # TODO: Remove in 26.05
    package = pkgs.unstable.pocket-id;
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
