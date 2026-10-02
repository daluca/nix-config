{
  flake.homeModules.discord = { config, ... }: {
    programs.discord.enable = true;

    home.persistence.home.directories = with config.programs; [
      ".config/${discord.configName}"
    ];
  };
}
