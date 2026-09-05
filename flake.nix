{
  description = "Personal NixOS configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-26.05";

    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    nixos-hardware.url = "github:nixos/nixos-hardware";
    nixos-hardware.inputs.nixpkgs.follows = "nixpkgs";

    home-manager.url = "github:nix-community/home-manager/release-26.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    impermanence.url = "github:nix-community/impermanence";
    impermanence.inputs.nixpkgs.follows = "nixpkgs-unstable";
    impermanence.inputs.home-manager.follows = "home-manager";

    nur.url = "github:nix-community/nur";
    nur.inputs.nixpkgs.follows = "nixpkgs-unstable";

    sops-nix.url = "github:mic92/sops-nix";
    sops-nix.inputs.nixpkgs.follows = "nixpkgs-unstable";

    disko.url = "github:nix-community/disko/v1.13.0";
    disko.inputs.nixpkgs.follows = "nixpkgs-unstable";

    git-hooks.url = "github:cachix/git-hooks.nix";
    git-hooks.inputs.nixpkgs.follows = "nixpkgs-unstable";

    nixos-raspberrypi.url = "github:nvmd/nixos-raspberrypi";

    deploy-rs.url = "github:serokell/deploy-rs";
    deploy-rs.inputs.nixpkgs.follows = "nixpkgs-unstable";

    nix-vscode-extensions.url = "github:nix-community/nix-vscode-extensions";
    nix-vscode-extensions.inputs.nixpkgs.follows = "nixpkgs-unstable";

    catppuccin.url = "github:catppuccin/nix/v26.05";
    catppuccin.inputs.nixpkgs.follows = "nixpkgs";

    nixvim-config.url = "github:daluca/nixvim-config";
    nixvim-config.inputs.nixpkgs.follows = "nixpkgs-unstable";

    fzf-preview.url = "github:niksingh710/fzf-preview";
    fzf-preview.inputs.nixpkgs.follows = "nixpkgs";

    zen-browser.url = "github:0xc000022070/zen-browser-flake";
    zen-browser.inputs.nixpkgs.follows = "nixpkgs-unstable";
    zen-browser.inputs.home-manager.follows = "home-manager";

    srvos.url = "github:nix-community/srvos";
    srvos.inputs.nixpkgs.follows = "nixpkgs-unstable";

    nix-index-database.url = "github:nix-community/nix-index-database";
    nix-index-database.inputs.nixpkgs.follows = "nixpkgs";

    proton-ge.url = "github:daluca/proton-ge-overlay";
    proton-ge.inputs.nixpkgs.follows = "nixpkgs";

    colmena.url = "github:zhaofengli/colmena";
    colmena.inputs.nixpkgs.follows = "nixpkgs-unstable";
    colmena.inputs.stable.follows = "nixpkgs";

    treefmt.url = "github:numtide/treefmt-nix";
    treefmt.inputs.nixpkgs.follows = "nixpkgs-unstable";

    flake-parts.url = "github:hercules-ci/flake-parts";

    import-tree.url = "github:denful/import-tree";

    nix-monitored.url = "github:ners/nix-monitored";
    nix-monitored.inputs.nixpkgs.follows = "nixpkgs-unstable";

    hister.url = "github:asciimoo/hister";
    hister.inputs.nixpkgs.follows = "nixpkgs-unstable";

    opendeck-nix.url = "github:kitt3120/opendeck-nix";
    opendeck-nix.inputs.nixpkgs.follows = "nixpkgs-unstable";
  };

  outputs =
    {
      self,
      nixpkgs,
      home-manager,
      ...
    }@inputs:
    let
      inherit (self) outputs;
      inherit (lib) nixosSystem;
      lib = nixpkgs.lib.extend (
        _final: _prev: { custom = import ./lib { inherit lib; }; } // home-manager.lib
      );
      secrets = fromTOML (builtins.readFile ./secrets/secrets.toml);
      supportedSystems = [
        "x86_64-linux"
        "aarch64-linux"
      ];
      forAllSystems = lib.genAttrs supportedSystems;
      pkgs' =
        system:
        import nixpkgs {
          inherit system;
          config.allowUnfree = true;
          overlays =
            with inputs;
            builtins.attrValues self.overlays
            ++ [
              nur.overlays.default
              nix-vscode-extensions.overlays.default
              proton-ge.overlays.default
            ];
        };
    in
    lib.recursiveUpdate {
      formatter = forAllSystems (
        system:
        let
          pkgs = pkgs' system;
        in
        (inputs.treefmt.lib.evalModule pkgs ./treefmt.nix).config.build.wrapper
      );

      overlays = import ./overlays { inherit inputs; };

      packages = forAllSystems (
        system:
        let
          pkgs = pkgs' system;
        in
        import ./pkgs { inherit pkgs; }
      );

      nixosModules = import ./legacyModules/nixos;

      homeManagerModules = import ./legacyModules/home-manager;

      nixosConfigurations.artemis = nixosSystem {
        system = "x86_64-linux";
        specialArgs = {
          inherit
            inputs
            outputs
            lib
            secrets
            ;
        };
        modules = [
          ./hosts/artemis
        ];
      };

      nixosConfigurations.ironforge = nixosSystem {
        system = "aarch64-linux";
        specialArgs = {
          inherit
            inputs
            outputs
            lib
            secrets
            ;
        };
        modules = [
          ./hosts/ironforge
        ];
      };

      nixosConfigurations.darnassus = nixosSystem {
        system = "aarch64-linux";
        specialArgs = {
          inherit
            inputs
            outputs
            lib
            secrets
            ;
        };
        modules = [
          ./hosts/darnassus
        ];
      };

      nixosConfigurations.guiltyspark = nixosSystem {
        system = "x86_64-linux";
        specialArgs = {
          inherit
            inputs
            outputs
            lib
            secrets
            ;
        };
        modules = [
          ./hosts/guiltyspark
        ];
      };

      nixosConfigurations.shodan = nixosSystem {
        system = "x86_64-linux";
        specialArgs = {
          inherit
            inputs
            outputs
            lib
            secrets
            ;
        };
        modules = [
          ./hosts/shodan
        ];
      };

      nixosConfigurations.unifi = nixosSystem {
        system = "x86_64-linux";
        specialArgs = {
          inherit
            inputs
            outputs
            lib
            secrets
            ;
        };
        modules = [
          ./hosts/unifi
        ];
      };
    } (inputs.flake-parts.lib.mkFlake { inherit inputs; } (inputs.import-tree ./modules));
}
