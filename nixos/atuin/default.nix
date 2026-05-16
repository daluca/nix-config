{
  config,
  ...
}:

{
  services.atuin = {
    enable = true;
    openRegistration = true;
  };

  systemd.tmpfiles.rules = with config.services; [
    "d ${dirOf postgresql.dataDir} 0750 postgres postgres -"
  ];

  environment.persistence.system.directories = with config.services; [
    {
      directory = postgresql.dataDir;
      user = "postgres";
      group = "postgres";
      mode = "0750";
    }
  ];
}
