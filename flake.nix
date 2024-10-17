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

    nixvim.url = "github:nix-community/nixvim";
    nixvim.inputs.nixpkgs.follows = "nixpkgs-unstable";
    nixvim.inputs.home-manager.follows = "home-manager";
    nixvim.inputs.git-hooks.follows = "git-hooks";

    terraform-oss.url = "github:nixos/nixpkgs?ref=517501bcf14ae6ec47efd6a17dda0ca8e6d866f9";

    git-hooks.url = "github:cachix/git-hooks.nix";
    git-hooks.inputs.nixpkgs.follows = "nixpkgs-unstable";
    git-hooks.inputs.nixpkgs-stable.follows = "nixpkgs";

    raspberry-pi-nix.url = "github:nix-community/raspberry-pi-nix";
    raspberry-pi-nix.inputs.nixpkgs.follows = "nixpkgs";

    deploy-rs.url = "github:serokell/deploy-rs";
    deploy-rs.inputs.nixpkgs.follows = "nixpkgs-unstable";
  };

  outputs = {self, nixpkgs, deploy-rs, ...} @ inputs:
  let
    inherit (self) outputs;
    inherit (nixpkgs.lib) nixosSystem getName;
    inherit (pkgs) sops git-agecrypt ssh-to-age just fd;
    pkgs = nixpkgs.legacyPackages."x86_64-linux";
    secrets = builtins.fromTOML (builtins.readFile ./secrets/secrets.toml);
  in
  {
    overlays = import ./overlays { inherit inputs getName; };

    devShells."x86_64-linux".default = pkgs.mkShell {
      name = "nix-config";
      buildInputs = [
        sops
        git-agecrypt
        ssh-to-age
        just
        fd
      ];
      JUST_COMMAND_COLOR = "blue";
    };

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

    deploy.nodes.stormwind = {
      hostname = "stormwind";
      interactiveSudo = true;
      profiles.system = {
        user = "root";
        path = deploy-rs.lib."aarch64-linux".activate.nixos self.nixosConfigurations.stormwind;
      };
    };

    checks = (builtins.mapAttrs (system: deployLib: deployLib.deployChecks self.deploy) deploy-rs.lib);
  };
}
