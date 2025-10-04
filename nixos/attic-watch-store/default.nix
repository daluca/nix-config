{ config, secrets, ... }:

{
  services.attic-watch-store = {
    enable = true;
    apiTokenFile = config.sops.secrets."attic/api-token".path;
    cache.endpoint = "https://attic.${secrets.domain.general}";
  };

  sops.secrets."attic/api-token" = { };
}
