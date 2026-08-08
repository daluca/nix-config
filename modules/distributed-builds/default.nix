{ self, ... }:

{
  flake.nixosModules.distributedBuilds = {
    imports = with self.nixosModules; [
      distributedBuilds-dalaran
    ];
    nix.distributedBuilds = true;
    nix.settings.builders-use-substitutes = true;
  };
}
