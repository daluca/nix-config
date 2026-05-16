{
  services.seerr = {
    enable = true;
  };

  systemd.tmpfiles.rules = [
    "d /var/lib/private 0700 - - -"
  ];

  environment.persistence.system.directories = [
    {
      directory = "/var/lib/private/seerr";
      mode = "0700";
      defaultPerms.mode = "0700";
    }
  ];
}
