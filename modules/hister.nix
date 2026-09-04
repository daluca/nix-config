{ inputs, ... }:

{
  flake.nixosModules.hister = { config, lib, ... }: {
    imports = with inputs; [
      hister.nixosModules.hister
    ];

    services.hister = {
      enable = true;
      port = 4433;
      dataDir = "/var/lib/hister";
      environmentFile = config.sops.templates."hister-secrets.env".path;
      settings = {
        app = {
          search_url = "https://kagi.com/search?q={query}";
          log_level = "debug";
          public = true;
        };
      };
    };

    sops.templates."hister-secrets.env" = with config.services; {
      owner = hister.user;
      group = hister.group;
      restartUnits = [ "hister.service" ];
      content = lib.generators.toKeyValue { } {
        HISTER__APP__ACCESS_TOKEN = config.sops.placeholder."hister/access-token";
      };
    };

    sops.secrets."hister/access-token" = { };
  };
}
