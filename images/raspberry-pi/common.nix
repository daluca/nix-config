{ lib, pkgs, inputs, ... }:
let
  inherit (lib) mkDefault;
  inherit (pkgs) libraspberrypi;
in {
  imports = [
    inputs.raspberry-pi-nix.nixosModules.raspberry-pi
  ];

  hardware.raspberry-pi.config.all = {
    dt-overlays.disable-bt = { enable = true; params = { }; };
  };

  environment.systemPackages = [
    libraspberrypi
  ];

  system.stateVersion = mkDefault "24.11";
}
