{ lib, pkgs, inputs, ... }:
let
  inherit (lib) mkDefault;
  inherit (pkgs) vim disko;
in {
  imports = [
    "${inputs.nixpkgs}/nixos/modules/installer/cd-dvd/installation-cd-minimal.nix"
  ];

  environment.systemPackages = [
    vim
    disko
  ];

  system.stateVersion = mkDefault "24.11";
}
