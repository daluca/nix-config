{ config, lib, pkgs, inputs, ... }:

{
  imports = with inputs; [
    impermanence.homeManagerModules.impermanence
  ];

  nix.package = pkgs.nix;

  nix.settings = {
    experimental-features = [ "nix-command" "flakes" ];
    substituters = [
      "https://cache.nixos.org/?priority=40"
      "https://nix-community.cachix.org/?priority=50"
    ];
    trusted-public-keys = [
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    ];
    warn-dirty = false;
  };

  nix.registry = builtins.mapAttrs (_: value: { flake = value; }) (builtins.removeAttrs inputs [ "self" ]) // {
    nix-config.flake = inputs.self;
    neovim.to = {
      path = "${config.home.homeDirectory}/code/github.com/daluca/nixvim-config";
      type = "path";
    };
  };

  nixpkgs.config = import ./nixpkgs-config.nix;
  xdg.configFile."nixpkgs/config.nix".source = ./nixpkgs-config.nix;

  home.persistence.home.enable = lib.mkDefault false;

  xdg.enable = true;

  xdg.mimeApps.enable = true;

  xdg.configFile."mimeapps.list".force = true;
  xdg.dataFile."applications/mimeapps.list".force = true;

  targets.genericLinux.enable = lib.mkDefault true;

  home.shellAliases = {
    "sudoedit" = /* bash */ ''EDITOR="$( command -v nvim )" sudoedit'';
  };
}
