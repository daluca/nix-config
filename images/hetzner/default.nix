{ lib, inputs, ... }:

{
  imports = [
    inputs.srvos.nixosModules.server
  ] ++ map (m: lib.custom.relativeToNixosModules m) [
    "openssh/server"
  ] ++ map (m: lib.custom.relativeToUsers m) [
    "root"
  ];

  boot.initrd.systemd.enable = false;

  documentation.nixos.enable = false;

  systemd.enableEmergencyMode = false;
}
