{ config, lib, pkgs, ... }:
let
  inherit (config.boot) kernelPackages;
  inherit (lib) mkForce;
  inherit (pkgs.unstable) linuxPackages_latest;
in {
  boot.kernelPackages = linuxPackages_latest;

  specialisation.gaming.configuration = {
    system.nixos.tags = [ "gaming" ];

    hardware.graphics = {
      enable = mkForce true;
      enable32Bit = mkForce true;
    };

    services.xserver.videoDrivers = mkForce [ "nvidia" ];

    hardware.nvidia = {
      modesetting.enable = mkForce true;
      package = mkForce kernelPackages.nvidiaPackages.beta;
      open = mkForce true;
      nvidiaSettings = mkForce true;
      powerManagement = {
        enable = mkForce true;
        finegrained = mkForce true;
      };
      prime = {
        reverseSync.enable = mkForce true;
        allowExternalGpu = mkForce true;
        intelBusId = mkForce "PCI:0:2:0";
        nvidiaBusId = mkForce "PCI:48:0:0";
      };
    };
  };
}
