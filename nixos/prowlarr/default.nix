{
  services.prowlarr = {
    enable = true;
  };

  environment.persistence.system.directories = [
    { directory = "/var/lib/private/prowlarr"; mode = "0700"; defaultPerms.mode = "0700"; }
  ];
}
