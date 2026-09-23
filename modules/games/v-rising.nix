{
  flake.homeModules.games-vRising = {
    programs.mangohud.settingsPerApplication = {
      wine-VRising = {
        preset = 1;
        position = "top-right";
        no_display = false;
      };
    };
  };
}
