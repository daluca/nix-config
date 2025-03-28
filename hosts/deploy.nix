{ deploy-rs, nixosConfigurations }:

{
  nodes = {
    stormwind = import ./stormwind/deploy.nix { inherit deploy-rs nixosConfigurations; };
    ironforge = import ./ironforge/deploy.nix { inherit deploy-rs nixosConfigurations; };
    darnassus = import ./darnassus/deploy.nix { inherit deploy-rs nixosConfigurations; };
    guiltyspark = import ./guiltyspark/deploy.nix { inherit deploy-rs nixosConfigurations; };
    unifi = import ./unifi/deploy.nix { inherit deploy-rs nixosConfigurations; };
  };
}
