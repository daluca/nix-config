{ self, ... }:

{
  flake.homeModules.games = {
    imports = with self.homeModules; [
      games-slayTheSpire2
      games-vRising
      games-cyberpunk2077
    ];
  };
}
