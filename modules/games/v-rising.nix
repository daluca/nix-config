{
  flake.homeManagerModules.games-vRising = {
    programs.mangohud.settingsPerApplication = {
      wine-VRising = {
        preset = 1;
        position = "top-left";
        no_display = false;
      };
    };
  };
}
