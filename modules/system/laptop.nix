{ self, ... }:

{
  flake.nixosModules.laptop = {
    imports = with self.nixosModules; [
      desktop
      battery
    ];
  };
}
