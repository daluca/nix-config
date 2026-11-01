{
  flake.nixosModules.jellyfin =
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
        {
          inherit (jellyfin) user group;
          directory = jellyfin.dataDir;
          mode = "0600";
        }
        {
          inherit (jellyfin) user group;
          directory = jellyfin.cacheDir;
          mode = "0600";
        }
      ];
    };
}
