{ inputs, ... }:

{
  imports = with inputs; [
    catppuccin.homeModules.catppuccin
  ];

  catppuccin = {
    flavor = "mocha";
  };
}
