{ pkgs, inputs, ... }:
let
  inherit (pkgs) libraspberrypi;
in {
  imports = [
    inputs.raspberry-pi-nix.nixosModules.sd-image
    inputs.raspberry-pi-nix.nixosModules.raspberry-pi
  ];

  documentation.nixos.enable = false;

  hardware.raspberry-pi.config.all = {
    dt-overlays.disable-bt = { enable = true; params = { }; };
  };

  environment.systemPackages = [
    libraspberrypi
  ];
}
