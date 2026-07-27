{ inputs, ... }:

{
  flake.nixosModules.catppuccin = {
    imports = with inputs; [
      catppuccin.nixosModules.catppuccin
    ];

    catppuccin.flavor = "mocha";
  };

  flake.homeManagerModules.catppuccin = {
    imports = with inputs; [
      catppuccin.homeModules.catppuccin
    ];

    catppuccin.flavor = "mocha";
  };
}
