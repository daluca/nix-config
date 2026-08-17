{
  flake.homeManagerModules.games-cyberpunk2077 = {
    programs.mangohud = {
      settingsPerApplication = {
        wine-Cyberpunk2077 = {
          preset = 1;
          position = "top-right";
          no_display = true;
        };
      };
    };
  };
}
