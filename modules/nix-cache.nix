{ self, ... }:

{
  flake.nixosModules.nixCache = {
    imports = with self.nixosModules; [
      hosts-dalaran-cache
    ];
  };
}
