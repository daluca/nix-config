{
  description = "Personal NixOS configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.05";

    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    nixos-hardware.url = "github:nixos/nixos-hardware";

    home-manager.url = "github:nix-community/home-manager/release-25.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    impermanence.url = "github:nix-community/impermanence";

    nur.url = "github:nix-community/nur";
    nur.inputs.nixpkgs.follows = "nixpkgs-unstable";

    sops-nix.url = "github:mic92/sops-nix";
    sops-nix.inputs.nixpkgs.follows = "nixpkgs-unstable";

    disko.url = "github:nix-community/disko/v1.11.0";
    disko.inputs.nixpkgs.follows = "nixpkgs-unstable";

    git-hooks.url = "github:cachix/git-hooks.nix";
    git-hooks.inputs.nixpkgs.follows = "nixpkgs-unstable";

    raspberry-pi-nix.url = "github:nix-community/raspberry-pi-nix";
    raspberry-pi-nix.inputs.nixpkgs.follows = "nixpkgs";

    deploy-rs.url = "github:serokell/deploy-rs";
    deploy-rs.inputs.nixpkgs.follows = "nixpkgs-unstable";

    nix-vscode-extensions.url = "github:nix-community/nix-vscode-extensions";
    nix-vscode-extensions.inputs.nixpkgs.follows = "nixpkgs-unstable";

    catppuccin.url = "github:catppuccin/nix";
    catppuccin.inputs.nixpkgs.follows = "nixpkgs-unstable";

    nixvim-config.url = "github:daluca/nixvim-config";
    nixvim-config.inputs.nixpkgs.follows = "nixpkgs-unstable";

    nixgl.url = "github:nix-community/nixgl";
    nixgl.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = {self, nixpkgs, home-manager, git-hooks, ...} @ inputs:
  let
    inherit (self) outputs;
    inherit (lib) nixosSystem homeManagerConfiguration;
    lib = nixpkgs.lib.extend (_final: _prev: { custom = import ./lib { inherit lib; }; } // home-manager.lib);
    secrets = fromTOML (builtins.readFile ./secrets/secrets.toml);
    supportedSystems = [ "x86_64-linux" "aarch64-linux" ];
    forAllSystems = nixpkgs.lib.genAttrs supportedSystems;
    pkgs' = system: import nixpkgs {
      inherit system;
      config.allowUnfree = true;
      overlays = with inputs; builtins.attrValues self.overlays ++ [
        nur.overlays.default
        nix-vscode-extensions.overlays.default
        nixgl.overlays.default
      ];
    };
  in {
    checks = forAllSystems (system:
      let
        pkgs = pkgs' system;
      in {
        pre-commit = git-hooks.lib.${system}.run {
          src = ./.;
          hooks = import ./.pre-commit-config.nix { inherit pkgs; };
        };
      } // inputs.deploy-rs.lib.${system}.deployChecks self.deploy
    );

    overlays = import ./overlays { inherit lib inputs; };

    packages = forAllSystems (system:
      let
        pkgs = pkgs' system;
      in
        import ./pkgs { inherit pkgs; }
    );

    nixosModules = import ./modules/nixos;

    homeManagerModules = import ./modules/home-manager;

    deploy = import ./hosts/deploy.nix { deploy-rs = inputs.deploy-rs; nixosConfigurations = self.nixosConfigurations; };

    devShells = forAllSystems (system:
      let
        pkgs = pkgs' system;
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
      specialArgs = { inherit inputs outputs lib system secrets; };
      modules = [
        ./hosts/artemis
      ];
    };

    nixosConfigurations.stormwind = nixosSystem rec {
      system = "aarch64-linux";
      specialArgs = { inherit inputs outputs lib system secrets; };
      modules = [
        ./hosts/stormwind
      ];
    };

    nixosConfigurations.ironforge = nixosSystem rec {
      system = "aarch64-linux";
      specialArgs = { inherit inputs outputs lib system secrets; };
      modules = [
        ./hosts/ironforge
      ];
    };

    nixosConfigurations.darnassus = nixosSystem rec {
      system = "aarch64-linux";
      specialArgs = { inherit inputs outputs lib system secrets; };
      modules = [
        ./hosts/darnassus
      ];
    };

    nixosConfigurations.guiltyspark = nixosSystem rec {
      system = "x86_64-linux";
      specialArgs = { inherit inputs outputs lib system secrets; };
      modules = [
        ./hosts/guiltyspark
      ];
    };

    nixosConfigurations.unifi = nixosSystem rec {
      system = "x86_64-linux";
      specialArgs = { inherit inputs outputs lib system secrets; };
      modules = [
        ./hosts/unifi
      ];
    };

    homeConfigurations."lucas.slebos@RRS-A00690" =
    let
      system = "x86_64-linux";
      pkgs = pkgs' system;
    in homeManagerConfiguration {
      inherit pkgs;
      extraSpecialArgs = { inherit inputs outputs lib system secrets; hostname = "RRS-A00746"; };
      modules = [
        ./users/lucas.slebos/home
      ];
    };

    homeConfigurations."lucas.slebos@RRS-A00746" =
    let
      system = "x86_64-linux";
      pkgs = pkgs' system;
    in homeManagerConfiguration {
      inherit pkgs;
      extraSpecialArgs = { inherit inputs outputs lib system secrets; hostname = "RRS-A00746"; };
      modules = [
        ./users/lucas.slebos/home
      ];
    };

    images.iso = (nixosSystem rec {
      system = "x86_64-linux";
      specialArgs = { inherit inputs outputs lib system secrets; };
      modules = [
        ./images/iso
      ];
    }).config.system.build.isoImage;

    images.raspberry-pi-4 = (nixosSystem rec {
      system = "aarch64-linux";
      specialArgs = { inherit inputs outputs lib system secrets; };
      modules = [
        ./images/raspberry-pi/4
      ];
    }).config.system.build.sdImage;

    images.digitalocean = (nixosSystem rec {
      system = "x86_64-linux";
      specialArgs = { inherit inputs outputs lib system secrets; };
      modules = [
        ./images/digitalocean
      ];
    }).config.system.build.digitalOceanImage;
  };
}
