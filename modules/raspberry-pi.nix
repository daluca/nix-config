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

  flake.nixosModules.raspberry-pi-4 = { lib, ... }: {
    imports =
      with inputs;
      with self.nixosModules;
      [
        "${inputs.nixpkgs}/nixos/modules/installer/sd-card/sd-image-aarch64.nix"

        nixos-hardware.nixosModules.raspberry-pi-4

        raspberry-pi
      ];

    colmena.tags = [
      "raspberry-pi-4"
    ];

    system.nixos.tags = [
      "rpi4"
    ];

    host.network.interface = "end0";

    boot.supportedFilesystems.zfs = lib.mkForce false;

    fileSystems."/boot/firmware".options = lib.mkForce [
      "nofail"
    ];

    hardware.raspberry-pi.firmware.enable = true;

    hardware.raspberry-pi.firmware.uboot.enable = true;

    boot.initrd.availableKernelModules = {
      dw-hdmi = lib.mkForce false;
      dw-mipi-dsi = lib.mkForce false;
      pcie-rockchip-host = lib.mkForce false;
      phy-rockchip-pcie = lib.mkForce false;
      pwm-sun4i = lib.mkForce false;
      rockchip-rga = lib.mkForce false;
      rockchipdrm = lib.mkForce false;
      sun4i-drm = lib.mkForce false;
      sun8i-mixer = lib.mkForce false;
    };
  };

  flake.nixosModules.raspberry-pi-4-poe-hat = {
    hardware.raspberry-pi.configtxt.deviceTreeOverlays."board-type=0x11" = [
      {
        rpi-poe = {
          poe_fan_temp0 = 65 * 1000;
          poe_fan_temp0_hyst = 2000;
          poe_fan_temp1 = 70 * 1000;
          poe_fan_temp1_hyst = 2000;
          poe_fan_temp2 = 75 * 1000;
          poe_fan_temp2_hyst = 2000;
          poe_fan_temp3 = 80 * 1000;
          poe_fan_temp3_hyst = 5000;
        };
      }
    ];
  };

  flake.nixosModules.raspberry-pi-5 = {
    imports =
      with inputs;
      with self.nixosModules;
      [
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
