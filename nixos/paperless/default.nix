{ config, ... }:

{
  services.paperless = {
    enable = true;
    passwordFile = config.sops.secrets."paperless/superuser-password".path;
  };

  sops.secrets."paperless/superuser-password" = {
    owner = config.services.paperless.user;
  };

  environment.persistence.system.directories = [
    config.services.paperless.dataDir
  ];
}
