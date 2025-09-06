{ lib, inputs, ... }:

{
  imports = [
    inputs.disko.nixosModules.disko

    ./disko.nix
  ] ++ map (m: lib.custom.relativeToRoot m) [
    "images/raspberry-pi/5"
  ] ++ map (m: lib.custom.relativeToHosts m) [
    "."
  ] ++ map (m: lib.custom.relativeToUsers m) [
    "remotebuild"
  ] ++ map (m: lib.custom.relativeToNixosModules m) [
    "openssh/server"
  ];

  networking.hostName = "dalaran";

  sops.secrets."ssh_host_ed25519_key".sopsFile = ./dalaran.sops.yaml;

  sops.secrets."ssh_host_rsa_key".sopsFile = ./dalaran.sops.yaml;

  hardware.raspberry-pi.config = {
    all.base-dt-params = {
      pciex1_gen = {
        enable = true;
        value = 3;
      };
    };
  };

  system.stateVersion = "25.05";
}
