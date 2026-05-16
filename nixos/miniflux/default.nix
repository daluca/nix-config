{
  config,
  lib,
  secrets,
  ...
}:

{
  services.miniflux = {
    enable = true;
    adminCredentialsFile = config.sops.templates."miniflux.env".path;
    config = {
      LISTEN_ADDR = "127.0.0.1:8081";
      BASE_URL = "https://miniflux.${secrets.domain.general}/";
      OAUTH2_PROVIDER = "oidc";
      OAUTH2_REDIRECT_URL = "https://miniflux.${secrets.domain.general}/oauth2/oidc/callback";
      OAUTH2_OIDC_DISCOVERY_ENDPOINT = "https://id.${secrets.domain.general}";
      OAUTH2_USER_CREATION = 1;
    };
  };

  sops.templates."miniflux.env".content = lib.generators.toKeyValue { } {
    ADMIN_USERNAME = "admin";
    ADMIN_PASSWORD = config.sops.placeholder."miniflux/admin-password";
    OAUTH2_CLIENT_ID = "d915465e-cc11-46b9-b522-928b63a5b2b5";
    OAUTH2_CLIENT_SECRET = config.sops.placeholder."miniflux/oidc/client-secret";
  };

  sops.secrets."miniflux/admin-password" = {
    restartUnits = [ "miniflux.service" ];
  };

  sops.secrets."miniflux/oidc/client-secret" = {
    restartUnits = [ "miniflux.service" ];
  };
}
