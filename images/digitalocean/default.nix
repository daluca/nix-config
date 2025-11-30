{ lib, modulesPath, ... }:

{
  imports = [
    (modulesPath + "/virtualisation/digital-ocean-image.nix")
  ] ++ map (m: lib.custom.relativeToNixosModules m) [
    "openssh/server"
  ] ++ map (m: lib.custom.relativeToUsers m) [
    "root"
  ];

  documentation.nixos.enable = false;

  system.stateVersion = "25.11";
}
