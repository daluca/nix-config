{ self, ... }:

{
  flake.nixosModules.nixCache = {
    imports = with self.nixosModules; [
      hosts-bravo-cache
      hosts-charlie-cache
      hosts-dalaran-cache
    ];
  };
}
