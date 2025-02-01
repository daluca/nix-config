{ deploy-rs, nixosConfigurations }:

{
  nodes = {
    stormwind = import ./stormwind/deploy.nix { inherit deploy-rs nixosConfigurations; };
    ironforge = import ./ironforge/deploy.nix { inherit deploy-rs nixosConfigurations; };
    darnassus = import ./darnassus/deploy.nix { inherit deploy-rs nixosConfigurations; };
    azeroth = import ./azeroth/deploy.nix { inherit deploy-rs nixosConfigurations; };
  };
}
