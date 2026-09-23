{ self, inputs, ... }:

{
  flake.nixosModules.catppuccin = {
    imports = with inputs; [
      catppuccin.nixosModules.catppuccin
    ];

    catppuccin.flavor = "mocha";

    home-manager.users.daluca.imports = with self.homeModules; [
      catppuccin
    ];
  };

  flake.homeModules.catppuccin = {
    imports = with inputs; [
      catppuccin.homeModules.catppuccin
    ];

    catppuccin.flavor = "mocha";
  };
}
