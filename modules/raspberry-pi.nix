{ self, inputs, ... }:

{
  flake.nixosModules.raspberry-pi = { pkgs, ... }: {
    documentation.nixos.enable = false;

    environment.systemPackages = with pkgs; [
      libraspberrypi
    ];
  };

  flake.nixosModules.raspberry-pi-5 = { config, ... }: {
    imports = with inputs; with self.nixosModules; [
      nixos-raspberrypi.nixosModules.raspberry-pi-5.base
      nixos-raspberrypi.nixosModules.raspberry-pi-5.display-vc4
      nixos-raspberrypi.nixosModules.raspberry-pi-5.bluetooth

      raspberry-pi
    ];

    system.nixos.tags = [
      "raspberry-pi-5"
      config.boot.loader.raspberry-pi.bootloader
      config.boot.kernelPackages.kernel.version
    ];

    boot.loader.raspberry-pi.bootloader = "kernel";
  };
}
