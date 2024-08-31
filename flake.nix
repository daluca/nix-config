{
  description = "Personal NixOS configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-24.05";

    nixpkgs-unstable.url = "github:nixos/nixpkgs?ref=nixos-unstable";

    nixos-hardware.url = "github:nixos/nixos-hardware";

    home-manager.url = "github:nix-community/home-manager?ref=release-24.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    impermanence.url = "github:nix-community/impermanence";

    nur.url = "github:nix-community/nur";

    sops-nix.url = "github:mic92/sops-nix";
    sops-nix.inputs.nixpkgs.follows = "nixpkgs-unstable";
    sops-nix.inputs.nixpkgs-stable.follows = "nixpkgs";

    nixvim.url = "github:nix-community/nixvim?ref=nixos-24.05";
    nixvim.inputs.nixpkgs.follows = "nixpkgs";
    nixvim.inputs.home-manager.follows = "home-manager";

    garden.url = "gitlab:garden-rs/garden?ref=v1.7.0";
    garden.inputs.nixpkgs.follows = "nixpkgs-unstable";

    terraform-oss.url = "github:nixos/nixpkgs?ref=517501bcf14ae6ec47efd6a17dda0ca8e6d866f9";
  };

  outputs = {self, nixpkgs, nixos-hardware, home-manager, ...} @ inputs:
  let
    inherit (self) outputs;
    system = "x86_64-linux";
    pkgs = nixpkgs.legacyPackages.${system};
    secrets = builtins.fromTOML (builtins.readFile ./secrets/secrets.toml);
    lib = pkgs.lib;
  in
  {
    overlays = import ./overlays { inherit lib inputs; };

    devShells.${system}.default = import ./shell.nix { inherit pkgs; };

    nixosConfigurations.artemis = nixpkgs.lib.nixosSystem {
      inherit system;
      specialArgs = { inherit inputs outputs system secrets; };
      modules = [
        ./hosts/artemis
      ];
    };
  };
}
