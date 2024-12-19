{ deploy-rs, nixosConfigurations }:

{
  nodes.stormwind = import ./stormwind.nix { inherit deploy-rs nixosConfigurations; };
  nodes.ironforge = import ./ironforge.nix { inherit deploy-rs nixosConfigurations; };
  nodes.darnassus = import ./darnassus.nix { inherit deploy-rs nixosConfigurations; };
}
