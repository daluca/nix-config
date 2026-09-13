{ self, ... }:

{
  flake.homeManagerModules.nix-utils = { pkgs, ... }: {
    imports = with self.homeManagerModules; [
      nh
      comma
    ];

    home.packages = with pkgs; [
      nix-inspect
    ];
  };
}
