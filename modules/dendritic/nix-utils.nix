{ inputs, ... }:

{
  flake.homeManagerModules.nix-utils = { pkgs, ... }: {
    imports = with inputs.self.homeManagerModules; [
      nh
    ];

    home.packages = with pkgs; [
      nix-inspect
    ];
  };
}
