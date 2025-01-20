{ inputs, ... }:

{
  imports = [
    inputs.catppuccin.homeManagerModules.catppuccin
  ];

  catppuccin = {
    flavor = "mocha";
  };
}
