{
  services.jellyseerr = {
    enable = true;
  };

  systemd.tmpfiles.rules = [
    "d /var/lib/private 0700 - - -"
  ];

  environment.persistence.system.directories = [
    { directory = "/var/lib/private/jellyseerr"; mode = "0700"; defaultPerms.mode = "0700"; }
  ];
}
