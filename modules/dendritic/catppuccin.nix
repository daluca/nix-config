{ inputs, ... }:

{
  flake.nixosModules.catppuccin = {
    imports = with inputs; [
      catppuccin.nixosModules.catppuccin
    ];

    catppuccin.flavor = "mocha";
  };
}
