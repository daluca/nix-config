{ config, pkgs, ... }:

{
  services.paperless = {
    enable = true;
    # NOTE: Replace with stable package in NixOS 25.11
    package = pkgs.unstable.paperless-ngx;
    passwordFile = config.sops.secrets."paperless/superuser-password".path;
  };

  sops.secrets."paperless/superuser-password" = {
    owner = config.services.paperless.user;
  };

  environment.persistence.system.directories = [
    config.services.paperless.dataDir
  ];
}
