{ self, ... }:

{
  flake.nixosModules.desktop = {
    imports = with self.nixosModules; [
      base
    ];
  };
}
