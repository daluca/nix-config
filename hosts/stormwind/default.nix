{ inputs, system, ... }:

{
  imports = [
    inputs.raspberry-pi-nix.nixosModules.raspberry-pi
  ];

  raspberry-pi-nix.board = "bcm2711";

  networking.hostName = "stormwind";

  nixpkgs.buildPlatform.system = "x86_64-linux";
  nixpkgs.hostPlatform.system = system;

  system.stateVersion = "24.05";
}
