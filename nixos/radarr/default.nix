{ config, ... }:

{
  services.radarr = {
    enable = true;
    user = "starr";
    group = "starr";
  };

  environment.persistence.system.directories = [
    config.services.radarr.dataDir
  ];
}
