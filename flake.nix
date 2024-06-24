{
  description = "NixOS system Flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.05";

    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixpkgs-unstable";

    nixos-hardware.url = "github:nixos/nixos-hardware/master";

    home-manager = {
      url = "github:nix-community/home-manager/release-24.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nur.url = "github:nix-community/nur";

    nixvim = {
      url = "github:nix-community/nixvim";
      inputs = {
        nixpkgs.follows = "nixpkgs-unstable";
        home-manager.follows = "nixpkgs";
      };
    };
  };

  outputs =
    inputs@{
      self,
      nixpkgs,
      nixpkgs-unstable,
      nixos-hardware,
      home-manager,
      nur,
      nixvim,
      ...
    }:
    let
      system = "x86_64-linux";
      username = "daluca";
      hostname = "nixos";
    in
    {
      formatter.${system} = nixpkgs.legacyPackages.${system}.nixfmt-rfc-style;

      nixosConfigurations.${hostname} = nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = {
          inherit inputs username;
        };
        modules = [
          (
            { config, pkgs, ... }:
            {
              nixpkgs.overlays = [ (self: super: { unstable = import nixpkgs-unstable { inherit system; }; }) ];
            }
          )

          { nixpkgs.overlays = [ nur.overlay ]; }

          nixos-hardware.nixosModules.lenovo-thinkpad-x1-7th-gen

          ./hosts/thinkpad

          home-manager.nixosModules.home-manager
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              extraSpecialArgs = {
                inherit inputs hostname username;
              };
              users.${username} = import ./home;
            };
          }
        ];
      };
    };
}
