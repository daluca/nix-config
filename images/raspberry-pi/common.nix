{ lib, pkgs, inputs, ... }:
let
  inherit (lib) mkDefault mkImageMediaOverride;
  inherit (pkgs) libraspberrypi;
in {
  imports = [
    inputs.raspberry-pi-nix.nixosModules.raspberry-pi
  ];

  documentation.nixos.enable = false;

  hardware.raspberry-pi.config.all = {
    dt-overlays.disable-bt = { enable = true; params = { }; };
  };

  environment.systemPackages = [
    libraspberrypi
  ];

  system.stateVersion = mkDefault "24.11";
}
