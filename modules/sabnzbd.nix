{
  flake.nixosModules.sabnzbd =
    { config, ... }:

    {
      services.sabnzbd = {
        enable = true;
        user = "starr";
        group = "starr";
        settings = {
          misc = {
            host = "127.0.0.1";
            port = 8080;
            complete_dir = "/storage/usenet/complete";
            download_dir = "/storage/usenet/incomplete";
            local_ranges = "100.64.0.0/24";
            inet_exposure = 4;
          };
        };
      };

      systemd.tmpfiles.rules = with config.services; [
        "d /storage/usenet 0775 root starr -"
        "d /storage/usenet/incomplete 0775 root starr -"
        "d /storage/usenet/complete 0775 root starr -"
        "d /storage/usenet/complete/tv 0775 root starr -"
        "d /storage/usenet/complete/movies 0775 root starr -"

        "d /var/lib/sabnzbd/backups 0775 ${sabnzbd.user} ${sabnzbd.group} -"
        "d /var/lib/sabnzbd/backups/nzbs 0775 ${sabnzbd.user} ${sabnzbd.group} -"
        "R /var/lib/sabnzbd/Downloads"
      ];

      environment.persistence.system.directories = with config.services; [
        {
          directory = "/var/lib/sabnzbd";
          user = sabnzbd.user;
          group = sabnzbd.group;
        }
      ];
    };
}
