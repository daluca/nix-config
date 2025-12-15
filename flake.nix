{
  description = "Personal NixOS configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";

    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    nixos-hardware.url = "github:nixos/nixos-hardware";

    home-manager.url = "github:nix-community/home-manager/release-25.11";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    impermanence.url = "github:nix-community/impermanence";

    nur.url = "github:nix-community/nur";
    nur.inputs.nixpkgs.follows = "nixpkgs-unstable";

    sops-nix.url = "github:mic92/sops-nix";
    sops-nix.inputs.nixpkgs.follows = "nixpkgs-unstable";

    disko.url = "github:nix-community/disko/v1.12.0";
    disko.inputs.nixpkgs.follows = "nixpkgs-unstable";

    git-hooks.url = "github:cachix/git-hooks.nix";
    git-hooks.inputs.nixpkgs.follows = "nixpkgs-unstable";

    raspberry-pi-nix.url = "github:nix-community/raspberry-pi-nix";
    raspberry-pi-nix.inputs.nixpkgs.follows = "nixpkgs";

    nixos-raspberrypi.url = "github:nvmd/nixos-raspberrypi";

    deploy-rs.url = "github:serokell/deploy-rs";
    deploy-rs.inputs.nixpkgs.follows = "nixpkgs-unstable";

    nix-vscode-extensions.url = "github:nix-community/nix-vscode-extensions";
    nix-vscode-extensions.inputs.nixpkgs.follows = "nixpkgs-unstable";

    catppuccin.url = "github:catppuccin/nix/main";
    catppuccin.inputs.nixpkgs.follows = "nixpkgs";

    nixvim-config.url = "github:daluca/nixvim-config";
    nixvim-config.inputs.nixpkgs.follows = "nixpkgs-unstable";

    nixgl.url = "github:nix-community/nixgl";
    nixgl.inputs.nixpkgs.follows = "nixpkgs";

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

    openthread-border-router.url = "github:mrene/nixpkgs/openthread-border-router";
  };

  outputs = { self, nixpkgs, home-manager, ... } @ inputs:
  let
    inherit (self) outputs;
    inherit (lib) nixosSystem homeManagerConfiguration;
    lib = nixpkgs.lib.extend (_final: _prev: { custom = import ./lib { inherit lib; }; } // home-manager.lib);
    secrets = fromTOML (builtins.readFile ./secrets/secrets.toml);
    supportedSystems = [ "x86_64-linux" "aarch64-linux" ];
    forAllSystems = lib.genAttrs supportedSystems;
    pkgs' = system: import nixpkgs {
      inherit system;
      config.allowUnfree = true;
      overlays = with inputs; builtins.attrValues self.overlays ++ [
        nur.overlays.default
        nix-vscode-extensions.overlays.default
        nixgl.overlays.default
        proton-ge.overlays.default
      ];
    };
  in with inputs; with outputs; {
    checks = forAllSystems (system:
      let
        pkgs = pkgs' system;
      in {
        pre-commit = git-hooks.lib.${system}.run {
          src = ./.;
          hooks = import ./.pre-commit-config.nix { inherit lib pkgs; };
        };
      } // deploy-rs.lib.${system}.deployChecks deploy
    );

    overlays = import ./overlays { inherit inputs; };

    packages = forAllSystems (system:
      let
        pkgs = pkgs' system;
      in
        import ./pkgs { inherit pkgs; }
    );

    nixosModules = import ./modules/nixos;

    homeManagerModules = import ./modules/home-manager;

    deploy = import ./hosts/deploy.nix { inherit deploy-rs nixosConfigurations; };

    devShells = forAllSystems (system:
      let
        inherit (checks.${system}) pre-commit;
        pkgs = pkgs' system;
      in {
        default = pkgs.mkShell {
          name = "nix-config";
          packages = with pkgs.unstable; pre-commit.enabledPackages ++ [
            sops
            git-agecrypt
            just
            fd
            deploy-rs
            colmena
          ];
          JUST_COMMAND_COLOR = "blue";
          shellHook = pre-commit.shellHook;
        };
      }
    );

    colmenaHive = inputs.colmena.lib.makeHive colmena;

    colmena = import ./hosts/colmena.nix { inherit inputs outputs; };

    nixosConfigurations.artemis = nixosSystem {
      system = "x86_64-linux";
      specialArgs = { inherit inputs outputs lib secrets; };
      modules = [
        ./hosts/artemis
      ];
    };

    nixosConfigurations.stormwind = nixosSystem {
      system = "aarch64-linux";
      specialArgs = { inherit inputs outputs lib secrets; };
      modules = [
        ./hosts/stormwind
      ];
    };

    nixosConfigurations.ironforge = nixosSystem {
      system = "aarch64-linux";
      specialArgs = { inherit inputs outputs lib secrets; };
      modules = [
        ./hosts/ironforge
      ];
    };

    nixosConfigurations.darnassus = nixosSystem {
      system = "aarch64-linux";
      specialArgs = { inherit inputs outputs lib secrets; };
      modules = [
        ./hosts/darnassus
      ];
    };

    nixosConfigurations.dalaran =
    let
      lib = nixos-raspberrypi.inputs.nixpkgs.lib.extend (_final: _prev: {
        custom = import ./lib { lib = nixos-raspberrypi.inputs.nixpkgs.lib; };
      } // home-manager.lib );
    in nixos-raspberrypi.lib.nixosSystem {
      system = "aarch64-linux";
      specialArgs = { inherit inputs outputs lib secrets nixos-raspberrypi; };
      modules = [
        ./hosts/dalaran
      ];
    };

    nixosConfigurations.homeassistant =
    let
      lib = nixos-raspberrypi.inputs.nixpkgs.lib.extend (_final: _prev: {
        custom = import ./lib { lib = nixos-raspberrypi.inputs.nixpkgs.lib; };
      } // home-manager.lib );
    in nixos-raspberrypi.lib.nixosSystem {
      system = "aarch64-linux";
      specialArgs = { inherit inputs outputs lib secrets nixos-raspberrypi; };
      modules = [
        ./hosts/homeassistant
      ];
    };

    nixosConfigurations.guiltyspark = nixosSystem {
      system = "x86_64-linux";
      specialArgs = { inherit inputs outputs lib secrets; };
      modules = [
        ./hosts/guiltyspark
      ];
    };

    nixosConfigurations.unifi = nixosSystem {
      system = "x86_64-linux";
      specialArgs = { inherit inputs outputs lib secrets; };
      modules = [
        ./hosts/unifi
      ];
    };

    nixosConfigurations.alfa = nixosSystem {
      system = "x86_64-linux";
      specialArgs = { inherit inputs outputs lib secrets; };
      modules = [
        ./hosts/alfa
      ];
    };

    nixosConfigurations.bravo = nixosSystem {
      system = "aarch64-linux";
      specialArgs = { inherit inputs outputs lib secrets; };
      modules = [
        ./hosts/bravo
      ];
    };

    nixosConfigurations.charlie = nixosSystem {
      system = "x86_64-linux";
      specialArgs = { inherit inputs outputs lib secrets; };
      modules = [
        ./hosts/charlie
      ];
    };

    homeConfigurations."lucas.slebos@RRS-A00690" =
    let
      system = "x86_64-linux";
      pkgs = pkgs' system;
    in homeManagerConfiguration {
      inherit pkgs;
      extraSpecialArgs = { inherit inputs outputs lib secrets; hostname = "RRS-A00690"; };
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
      extraSpecialArgs = { inherit inputs outputs lib secrets; hostname = "RRS-A00746"; };
      modules = [
        ./users/lucas.slebos/home
      ];
    };
  };
}
