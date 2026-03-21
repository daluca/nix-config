{ lib, ... }:

{
  imports = [
    ./..
    ./disko.nix
  ] ++ map (m: lib.custom.relativeToRoot m) [
    "images/hetzner/cloud/x86"
  ] ++ map (m: lib.custom.relativeToNixosModules m) [
    "impermanence/grub"
    "remote-unlocking/dhcp"
  ];

  networking.hostName = "delta";

  system.stateVersion = "25.11";
}
