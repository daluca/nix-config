{ config, lib, inputs, ... }:
let
  inherit (config.networking) hostName;
in {
  imports = [
    inputs.sops-nix.nixosModules.sops
  ];

  sops = {
    defaultSopsFile = lib.custom.relativeToHosts "${hostName}/${hostName}.sops.yaml";
    age.keyFile = "/var/lib/sops-nix/keys.txt";
    age.sshKeyPaths = [ ];
    gnupg.sshKeyPaths = [ ];
  };
}
