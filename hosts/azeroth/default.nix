{ config, lib, inputs, ... }:

{
  imports = [
    inputs.nixos-hardware.nixosModules.common-cpu-intel
    inputs.disko.nixosModules.disko

    ./disko.nix
  ] ++ map (m: lib.custom.relativeToHosts m) [
    "."
  ] ++ map (m: lib.custom.relativeToNixosModules m) [
    "grub"
    "openssh/server"
  ] ++ map (m: lib.custom.relativeToUsers m) [
    "remotebuild"
  ];

  networking = {
    hostName = "azeroth";
    hostId = "5c9bd4a2";
  };

  boot.initrd.systemd.emergencyAccess = config.user.users.root.hashedPassword;

  sops.secrets."ssh_host_ed25519_key".sopsFile = ./azeroth.sops.yaml;

  sops.secrets."ssh_host_rsa_key".sopsFile = ./azeroth.sops.yaml;

  system.stateVersion = "24.11";
}
