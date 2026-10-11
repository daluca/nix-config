{
  flake.nixosModules.sabnzbd =
    { config, ... }:

    {
      services.sabnzbd = {
        enable = true;
        user = "starr";
        group = "starr";
        secretValues = {
          "@sabnzbd_username@" = config.sops.secrets."sabnzbd/username".path;
          "@sabnzbd_password@" = config.sops.secrets."sabnzbd/password".path;
          "@sabnzbd_api_key@" = config.sops.secrets."sabnzbd/api-key".path;
          "@sabnzbd_nzb_key@" = config.sops.secrets."sabnzbd/nzb-key".path;
          "@newshosting_username@" = config.sops.secrets."newshosting.com/username".path;
          "@newshosting_password@" = config.sops.secrets."newshosting.com/password".path;
        };
        settings = {
          servers = {
            "news.newshosting.com" = {
              name = "news.newshosting.com";
              displayname = "news.newshosting.com";
              host = "news.newshosting.com";
              port = 563;
              username = "@newshosting_username@";
              password = "@newshosting_password@";
              connections = 50;
              expire_date = "2027-01-14";
              required = true;
            };
          };
          misc = {
            host = "127.0.0.1";
            port = 8080;
            username = "@sabnzbd_username@";
            password = "@sabnzbd_password@";
            api_key = "@sabnzbd_api_key@";
            nzb_key = "@sabnzbd_nzb_key@";
            complete_dir = "/storage/usenet/complete";
            download_dir = "/storage/usenet/incomplete";
            local_ranges = "100.64.0.0/24";
            inet_exposure = 4;
          };
          categories = {
            movies.dir = "movies";
            tv.dir = "tv";
          };
        };
      };

      sops.secrets."newshosting.com/username" = {
        inherit (config.services.sabnzbd) group;
        owner = config.services.sabnzbd.user;
        restartUnits = [ "sabnzbd.service" ];
      };

      sops.secrets."newshosting.com/password" = {
        inherit (config.services.sabnzbd) group;
        owner = config.services.sabnzbd.user;
        restartUnits = [ "sabnzbd.service" ];
      };

      sops.secrets."sabnzbd/username" = {
        inherit (config.services.sabnzbd) group;
        owner = config.services.sabnzbd.user;
        restartUnits = [ "sabnzbd.service" ];
      };

      sops.secrets."sabnzbd/password" = {
        inherit (config.services.sabnzbd) group;
        owner = config.services.sabnzbd.user;
        restartUnits = [ "sabnzbd.service" ];
      };

      sops.secrets."sabnzbd/api-key" = {
        inherit (config.services.sabnzbd) group;
        owner = config.services.sabnzbd.user;
        restartUnits = [ "sabnzbd.service" ];
      };

      sops.secrets."sabnzbd/nzb-key" = {
        inherit (config.services.sabnzbd) group;
        owner = config.services.sabnzbd.user;
        restartUnits = [ "sabnzbd.service" ];
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
          inherit (sabnzbd) user group;
          directory = "/var/lib/sabnzbd";
        }
      ];
    };
}
