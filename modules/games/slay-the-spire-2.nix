{
  flake.homeManagerModules.games-slayTheSpire2 = {
    programs.mangohud.settingsPerApplication = {
      SlayTheSpire2 = {
        preset = 1;
        position = "top-left";
        no_display = true;
      };
    };

    home.persistence.home.directories = [
      ".local/share/SlayTheSpire2"
    ];
  };
}
