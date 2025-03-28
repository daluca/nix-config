{ lib, inputs, ... }:

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
    "tailscale/server"
  ] ++ map (m: lib.custom.relativeToUsers m) [
    "remotebuild"
  ];

  networking = {
    hostName = "guiltyspark";
    hostId = "5c9bd4a2";
  };

  sops.secrets."ssh_host_ed25519_key".sopsFile = ./guiltyspark.sops.yaml;

  sops.secrets."ssh_host_rsa_key".sopsFile = ./guiltyspark.sops.yaml;

  sops.secrets."tailscale/preauthkey".sopsFile = ./guiltyspark.sops.yaml;

  services.tailscale.extraUpFlags = [
    "--advertise-routes=192.168.1.0/24"
  ];

  system.stateVersion = "24.11";
}
