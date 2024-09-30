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
    nixvim.inputs.git-hooks.follows = "git-hooks";

    terraform-oss.url = "github:nixos/nixpkgs?ref=517501bcf14ae6ec47efd6a17dda0ca8e6d866f9";

    git-hooks.url = "github:cachix/git-hooks.nix";
    git-hooks.inputs.nixpkgs.follows = "nixpkgs-unstable";
    git-hooks.inputs.nixpkgs-stable.follows = "nixpkgs";
  };

  outputs = {self, nixpkgs, git-hooks, ...} @ inputs:
  let
    inherit (self) outputs;
    system = "x86_64-linux";
    pkgs = nixpkgs.legacyPackages.${system};
    secrets = builtins.fromTOML (builtins.readFile ./secrets/secrets.toml);
    lib = pkgs.lib;
    inherit (pkgs) sops just git-agecrypt;
  in
  {
    overlays = import ./overlays { inherit lib inputs; };

    checks.${system}.pre-commit-check = git-hooks.lib.${system}.run {
      src = ./.;
      hooks = {
        check-added-large-files.enable = true;
        check-merge-conflicts.enable = true;
        detect-private-keys.enable = true;
        end-of-file-fixer.enable = true;
        forbid-new-submodules.enable = true;
        trim-trailing-whitespace.enable = true;
      };
    };

    devShells.${system}.default = pkgs.mkShell {
      inherit (self.checks.${system}.pre-commit-check) shellHook;
      name = "nix-config";
      buildInputs = [
        sops
        git-agecrypt
        just
      ] ++ self.checks.${system}.pre-commit-check.enabledPackages;
      JUST_COMMAND_COLOR = "blue";
    };

    nixosConfigurations.artemis = nixpkgs.lib.nixosSystem {
      inherit system;
      specialArgs = { inherit inputs outputs system secrets; };
      modules = [
        ./hosts/artemis
      ];
    };

    nixosConfigurations.stormwind = nixpkgs.lib.nixosSystem {
      system = "aarch64-linux";
      specialArgs = { inherit inputs outputs secrets; system = "aarch64-linux"; };
      modules = [
        ./hosts/stormwind
      ];
    };
  };
}
