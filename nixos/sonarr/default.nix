{ config, ... }:

{
  services.sonarr = {
    enable = true;
    user = "starr";
    group = "starr";
  };

  environment.persistence.system.directories = [
    config.services.sonarr.dataDir
  ];
}
