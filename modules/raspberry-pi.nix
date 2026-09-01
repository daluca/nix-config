{ self, inputs, ... }:

{
  flake.nixosModules.raspberry-pi = { pkgs, ... }: {
    documentation.nixos.enable = false;

    environment.systemPackages = with pkgs; [
      libraspberrypi
    ];

    colmena.tags = [
      "rpi"
      "raspberry-pi"
    ];
  };

  flake.nixosModules.raspberry-pi-5 = {
    imports = with inputs; with self.nixosModules; [
      nixos-raspberrypi.nixosModules.raspberry-pi-5.base
      nixos-raspberrypi.nixosModules.raspberry-pi-5.display-vc4
      nixos-raspberrypi.nixosModules.raspberry-pi-5.bluetooth

      raspberry-pi
    ];

    system.nixos.tags = [
      "rpi5"
    ];

    colmena.tags = [
      "raspberry-pi-5"
    ];

    boot.loader.raspberry-pi.bootloader = "kernel";
  };
}
