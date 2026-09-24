{ self, ... }:

{
  flake.nixosModules.nixCache = {
    imports = with self.nixosModules; [
      alfa-cache
      bravo-cache
      charlie-cache
      shodan-cache
      guiltyspark-cache
      dalaran-cache
    ];
  };
}
