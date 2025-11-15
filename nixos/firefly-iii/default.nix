{ config, pkgs, ... }:
let
  firefly-iii = config.services.firefly-iii;
in {
  services.firefly-iii = {
    enable = true;
    # NOTE: Remove in NixOS 25.11
    package = pkgs.unstable.firefly-iii;
    enableNginx = true;
    settings = {
      APP_KEY_FILE = config.sops.secrets."firefly-iii/app.key".path;
      APP_ENV = "production";
    };
  };

  sops.secrets."firefly-iii/app.key" = {
    owner = firefly-iii.user;
    group = firefly-iii.group;
  };

  services.firefly-iii-data-importer = {
    enable = true;
    # NOTE: Remove in 25.11
    package = pkgs.unstable.firefly-iii-data-importer;
    enableNginx = true;
    settings = {
      APP_ENV = "production";
    };
  };
}
