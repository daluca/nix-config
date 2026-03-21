{ config, ... }:

{
  services.sabnzbd = {
    enable = true;
    openFirewall = true;
    user = "starr";
    group = "starr";
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
    { directory = "/var/lib/sabnzbd"; user = sabnzbd.user; group = sabnzbd.group; }
  ];
}
