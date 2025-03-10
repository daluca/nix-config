{
  description = "Personal NixOS configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.11";

    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    nixos-hardware.url = "github:nixos/nixos-hardware";

    home-manager.url = "github:nix-community/home-manager/release-24.11";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    impermanence.url = "github:nix-community/impermanence";

    nur.url = "github:nix-community/nur";
    nur.inputs.nixpkgs.follows = "nixpkgs-unstable";

    sops-nix.url = "github:mic92/sops-nix";
    sops-nix.inputs.nixpkgs.follows = "nixpkgs-unstable";

    disko.url = "github:nix-community/disko/v1.10.0";
    disko.inputs.nixpkgs.follows = "nixpkgs-unstable";

    terraform-oss.url = "github:nixos/nixpkgs/517501bcf14ae6ec47efd6a17dda0ca8e6d866f9";

    git-hooks.url = "github:cachix/git-hooks.nix";
    git-hooks.inputs.nixpkgs.follows = "nixpkgs-unstable";

    raspberry-pi-nix.url = "github:nix-community/raspberry-pi-nix";
    raspberry-pi-nix.inputs.nixpkgs.follows = "nixpkgs";

    deploy-rs.url = "github:serokell/deploy-rs";
    deploy-rs.inputs.nixpkgs.follows = "nixpkgs-unstable";

    arkenfox.url = "github:dwarfmaster/arkenfox-nixos";
    arkenfox.inputs.nixpkgs.follows = "nixpkgs";
    arkenfox.inputs.pre-commit.follows = "git-hooks";

    nix-vscode-extensions.url = "github:nix-community/nix-vscode-extensions";
    nix-vscode-extensions.inputs.nixpkgs.follows = "nixpkgs-unstable";

    catppuccin.url = "github:catppuccin/nix";
    catppuccin.inputs.nixpkgs.follows = "nixpkgs-unstable";

    nixvim-config.url = "github:daluca/nixvim-config";
    nixvim-config.inputs.nixpkgs.follows = "nixpkgs-unstable";
  };

  outputs = {self, nixpkgs, git-hooks, ...} @ inputs:
  let
    inherit (self) outputs;
    inherit (nixpkgs) lib;
    inherit (lib) nixosSystem;
    secrets = fromTOML (builtins.readFile ./secrets/secrets.toml);
    supportedSystems = [ "x86_64-linux" "aarch64-linux" ];
    forAllSystems = nixpkgs.lib.genAttrs supportedSystems;
  in {
    checks = forAllSystems (system:
      let
        pkgs = import nixpkgs {
          inherit system;
          overlays = builtins.attrValues self.overlays;
        };
      in {
        pre-commit = git-hooks.lib.${system}.run {
          src = ./.;
          hooks = import ./.pre-commit-config.nix { inherit pkgs; };
        };
      } // inputs.deploy-rs.lib.${system}.deployChecks self.deploy
    );

    overlays = import ./overlays { inherit lib inputs; };

    packages = forAllSystems (system: import ./pkgs { pkgs = nixpkgs.legacyPackages.${system}; });

    homeManagerModules = import ./modules/home-manager;

    deploy = import ./hosts/deploy.nix { deploy-rs = inputs.deploy-rs; nixosConfigurations = self.nixosConfigurations; };

    devShells = forAllSystems (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        pre-commit = self.checks.${system}.pre-commit;
      in {
        default = pkgs.mkShell {
          inherit (pre-commit) shellHook;
          name = "nix-config";
          buildInputs = with pkgs; [
            sops
            git-agecrypt
            ssh-to-age
            just
            fd
            deploy-rs
          ] ++ pre-commit.enabledPackages;
          JUST_COMMAND_COLOR = "blue";
        };
      }
    );

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

    nixosConfigurations.darnassus = nixosSystem rec {
      system = "aarch64-linux";
      specialArgs = { inherit inputs outputs system secrets; };
      modules = [
        ./hosts/darnassus
      ];
    };

    nixosConfigurations.azeroth = nixosSystem rec {
      system = "x86_64-linux";
      specialArgs = { inherit inputs outputs system secrets; };
      modules = [
        ./hosts/azeroth
      ];
    };

    nixosConfigurations.unifi = nixosSystem rec {
      system = "x86_64-linux";
      specialArgs = { inherit inputs outputs system secrets; };
      modules = [
        ./hosts/unifi
      ];
    };

    images.iso = (nixosSystem {
      system = "x86_64-linux";
      specialArgs = { inherit inputs outputs; };
      modules = [
        ./images/iso
      ];
    }).config.system.build.isoImage;

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
