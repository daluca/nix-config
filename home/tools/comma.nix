{ inputs, ... }:

{
  imports = with inputs; [
    nix-index-database.homeModules.nix-index
  ];

  programs.nix-index-database.comma.enable = true;
}
