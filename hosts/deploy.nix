{ deploy-rs, nixosConfigurations }:

{
  nodes = {
    stormwind = import ./stormwind/deploy.nix { inherit deploy-rs nixosConfigurations; };
    ironforge = import ./ironforge/deploy.nix { inherit deploy-rs nixosConfigurations; };
    darnassus = import ./darnassus/deploy.nix { inherit deploy-rs nixosConfigurations; };
    dalaran = import ./dalaran/deploy.nix { inherit deploy-rs nixosConfigurations; };
    guiltyspark = import ./guiltyspark/deploy.nix { inherit deploy-rs nixosConfigurations; };
    unifi = import ./unifi/deploy.nix { inherit deploy-rs nixosConfigurations; };
    alfa = import ./alfa/deploy.nix { inherit deploy-rs nixosConfigurations; };
    bravo = import ./bravo/deploy.nix { inherit deploy-rs nixosConfigurations; };
    charlie = import ./charlie/deploy.nix { inherit deploy-rs nixosConfigurations; };
  };
}
