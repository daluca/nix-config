{ self, ... }:

{
  flake.homeManagerModules.games = {
    imports = with self.homeManagerModules; [
      games-slayTheSpire2
      games-vRising
      games-cyberpunk2077
    ];
  };
}
