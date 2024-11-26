{
  description = "Personal NixOS configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-24.11";

    nixpkgs-unstable.url = "github:nixos/nixpkgs?/nixos-unstable";

    nixos-hardware.url = "github:nixos/nixos-hardware";

    home-manager.url = "github:nix-community/home-manager/release-24.11";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    impermanence.url = "github:nix-community/impermanence";

    nur.url = "github:nix-community/nur";

    sops-nix.url = "github:mic92/sops-nix";
    sops-nix.inputs.nixpkgs.follows = "nixpkgs-unstable";

    nixvim.url = "github:nix-community/nixvim";
    nixvim.inputs.nixpkgs.follows = "nixpkgs-unstable";
    nixvim.inputs.home-manager.follows = "home-manager";
    nixvim.inputs.git-hooks.follows = "git-hooks";

    terraform-oss.url = "github:nixos/nixpkgs/517501bcf14ae6ec47efd6a17dda0ca8e6d866f9";

    git-hooks.url = "github:cachix/git-hooks.nix";
    git-hooks.inputs.nixpkgs.follows = "nixpkgs-unstable";
    git-hooks.inputs.nixpkgs-stable.follows = "nixpkgs";

    raspberry-pi-nix.url = "github:nix-community/raspberry-pi-nix/v0.4.1";
    raspberry-pi-nix.inputs.nixpkgs.follows = "nixpkgs";

    deploy-rs.url = "github:serokell/deploy-rs";
    deploy-rs.inputs.nixpkgs.follows = "nixpkgs-unstable";
  };

  outputs = {self, nixpkgs, git-hooks, deploy-rs, ...} @ inputs:
  let
    inherit (self) outputs;
    inherit (nixpkgs.lib) nixosSystem getName;
    secrets = builtins.fromTOML (builtins.readFile ./secrets/secrets.toml);
    supportedSystems = [ "x86_64-linux" "aarch64-linux" ];
    forAllSystems = nixpkgs.lib.genAttrs supportedSystems;
  in {
    checks = forAllSystems (system: {
      pre-commit-check = git-hooks.lib.${system}.run {
        src = ./.;
        hooks = import ./.pre-commit-config.nix { pkgs = import nixpkgs { inherit system; overlays = builtins.attrValues self.overlays; }; };
      };
    } // deploy-rs.lib.${system}.deployChecks self.deploy);

    overlays = import ./overlays { inherit inputs getName; };

    packages = forAllSystems (system: import ./pkgs { pkgs = nixpkgs.legacyPackages.${system}; });

    homeManagerModules = import ./modules/home-manager;

    devShells = forAllSystems (system: {
      default =  nixpkgs.legacyPackages.${system}.mkShell {
        inherit (self.checks.${system}.pre-commit-check) shellHook;
        name = "nix-config";
        buildInputs = with nixpkgs.legacyPackages.${system}; [
          sops
          git-agecrypt
          ssh-to-age
          just
          fd
          nixpkgs.legacyPackages.${system}.deploy-rs
        ] ++ self.checks.${system}.pre-commit-check.enabledPackages;
        JUST_COMMAND_COLOR = "blue";
      };
    });

    nixosConfigurations.artemis = nixosSystem rec {
      system = "x86_64-linux";
      specialArgs = { inherit inputs outputs system secrets; };
      modules = [
        ./hosts/artemis
      ];
    };

    nixosConfigurations.stormwind = nixosSystem rec {
      system = "aarch64-linux";
      specialArgs = { inherit inputs outputs system secrets; };
      modules = [
        ./hosts/stormwind
      ];
    };

    nixosConfigurations.ironforge = nixosSystem rec {
      system = "aarch64-linux";
      specialArgs = { inherit inputs outputs system secrets; };
      modules = [
        ./hosts/ironforge
      ];
    };

    deploy.nodes.stormwind = {
      hostname = "stormwind";
      interactiveSudo = true;
      profiles.system = {
        user = "root";
        path = deploy-rs.lib."aarch64-linux".activate.nixos self.nixosConfigurations.stormwind;
      };
    };

    deploy.nodes.ironforge = {
      hostname = "ironforge";
      sshUser = "root";
      profiles.system = {
        user = "root";
        path = deploy-rs.lib."aarch64-linux".activate.nixos self.nixosConfigurations.ironforge;
      };
    };

    images.raspberry-pi-4 = (nixosSystem rec {
      system = "aarch64-linux";
      specialArgs = { inherit inputs outputs system secrets; };
      modules = [
        ./images/raspberry-pi/4
        {
          nixpkgs.buildPlatform.system = "x86_64-linux";
          nixpkgs.hostPlatform.system = system;
        }
      ];
    }).config.system.build.sdImage;

    images.digitalocean = (nixosSystem rec {
      system = "x86_64-linux";
      specialArgs = { inherit inputs outputs system secrets; };
      modules = [
        ./images/digitalocean
      ];
    }).config.system.build.digitalOceanImage;
  };
}
