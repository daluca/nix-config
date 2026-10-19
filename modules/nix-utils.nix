{ self, ... }:

{
  flake.homeModules.nix-utils = {
    imports = with self.homeModules; [
      nh
      nix-inspect
    ];
  };
}
