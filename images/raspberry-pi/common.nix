{ pkgs, modulesPath, inputs, ... }:
let
  inherit (pkgs) libraspberrypi;
in {
  imports = [
    inputs.raspberry-pi-nix.nixosModules.raspberry-pi

    # "${modulesPath}/installer/sd-card/sd-image.nix"
    # ./btrfs-build.nix
    # ./rpi-nix-image.nix
  ];

  disabledModules = [
    # "${modulesPath}/profiles/all-hardware.nix"
    # "${modulesPath}/installer/sd-card/sd-image.nix"
    # "${inputs.raspberry-pi-nix.nixosModules.raspberry-pi}/sd-image/sd-image.nix"
  ];

  # disabledModules = map (m: /. + "${modulesPath}/${m}") [
  #   "profiles/all-hardware.nix"
  # ];

  # imports = [
  #   # ./sd-image-raspberrypi.nix
  #   ./btrfs-build.nix
  # ];

  # disabledModules = [
  #   # "installer/sdcard/sd-image.nix"
  #   "${pkgs}/nixos/modules/installer/sdcard/sd-image.nix"
  # ];

  environment.systemPackages = [
    libraspberrypi
  ];

  hardware.raspberry-pi.config = {
    pi4 = {
      dt-overlays = {
        "gpio-fan" = {
          enable = true;
          params.gpiopin = { enable = true; value = 14; };
          params.temp = { enable = true; value = 80 * 1000; };
        };
      };

      # dt-overlays = {
      #   gpio-fan = {
      #     enable = true;
      #     params.gpiopin = { enable = true; value = (80 * 1000); };
      #   };
      # };

      # dt-overlays = {
      #   rpi-poe = {
      #     enable = true;
      #     params = {
      #       poe_fan_temp0 = { enable = true; value = 60000; };
      #       poe_fan_temp1 = { enable = true; value = 65000; };
      #       poe_fan_temp2 = { enable = true; value = 70000; };
      #       poe_fan_temp3 = { enable = true; value = 80000; };
      #     };
      #   };
      # };


      # base-dt-params = {
      #   poe_fan_temp0 = {
      #     enable = true;
      #     value = 60000;
      #   };
      #   poe_fan_temp1 = {
      #     enable = true;
      #     value = 70000;
      #   };
      #   poe_fan_temp2 = {
      #     enable = true;
      #     value = 75000;
      #   };
      #   poe_fan_temp3 = {
      #     enable = true;
      #     value = 80000;
      #   };
      # };
    };
  };

  nixpkgs.hostPlatform.system = "aarch64-linux";
  nixpkgs.buildPlatform.system = "x86_64-linux";
}
