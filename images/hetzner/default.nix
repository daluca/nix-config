{ lib, modulesPath, ... }:

{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
    (modulesPath + "/profiles/qemu-guest.nix")
  ] ++ map (m: lib.custom.relativeToNixosModules m) [
    "openssh/server"
  ] ++ map (m: lib.custom.relativeToUsers m) [
    "root"
  ];

  boot.loader.grub = {
    enable = true;
    efiSupport = false;
  };

  systemd.enableEmergencyMode = false;
}
