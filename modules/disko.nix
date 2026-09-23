{ inputs, ... }:

{
  imports = with inputs; [
    disko.flakeModules.disko
  ];
}
