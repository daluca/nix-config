{ lib, ... }:

{
  imports = map (m: lib.custom.relativeToRoot m) [
    "images/digitalocean"
  ] ++ map (m: lib.custom.relativeToHosts m) [
    "."
  ] ++ map (m: lib.custom.relativeToNixosModules m) [
    "openssh/server"
    "unifi-controller"
  ];

  networking.hostName = "unifi";
  networking.enableIPv6 = false;

  sops.secrets."ssh_host_ed25519_key".sopsFile = ./unifi.sops.yaml;

  sops.secrets."ssh_host_rsa_key".sopsFile = ./unifi.sops.yaml;

  system.stateVersion = "25.05";
}
