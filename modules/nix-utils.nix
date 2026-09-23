{ self, ... }:

{
  flake.homeModules.nix-utils = { pkgs, ... }: {
    imports = with self.homeModules; [
      nh
      comma
    ];

    home.packages = with pkgs; [
      nix-inspect
    ];
  };
}
