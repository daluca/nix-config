{ config, lib, pkgs, ... }:

{
  boot.kernelPackages = pkgs.unstable.linuxPackages;

  specialisation.gaming.configuration = {
    system.nixos.tags = [ "gaming" ];

    hardware.graphics = {
      enable = lib.mkForce true;
      enable32Bit = lib.mkForce true;
    };

    services.xserver.videoDrivers = lib.mkForce [ "nvidia" ];

    hardware.nvidia = {
      modesetting.enable = lib.mkForce true;
      package = lib.mkForce config.boot.kernelPackages.nvidiaPackages.beta;
      open = lib.mkForce true;
      nvidiaSettings = lib.mkForce true;
      powerManagement = {
        enable = lib.mkForce true;
        finegrained = lib.mkForce true;
      };
      prime = {
        reverseSync.enable = lib.mkForce true;
        allowExternalGpu = lib.mkForce true;
        intelBusId = lib.mkForce "PCI:0:2:0";
        nvidiaBusId = lib.mkForce "PCI:48:0:0";
      };
    };
  };
}
