{ config, ... }:

{
  services.jellyfin = {
    enable = true;
  };

  systemd.tmpfiles.rules = [
    "d /storage/media 0775 root starr -"
    "d /storage/media/tv 0775 root starr -"
    "d /storage/media/movies 0775 root starr -"
  ];

  environment.persistence.system.directories = with config.services; [
    { directory = jellyfin.dataDir; user = jellyfin.user; group = jellyfin.group; mode = "0600"; }
    { directory = jellyfin.cacheDir; user = jellyfin.user; group = jellyfin.group; mode = "0600"; }
  ];
}
