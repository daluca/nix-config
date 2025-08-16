{ lib, inputs, ... }:

{
  imports = [
    inputs.sops-nix.nixosModules.sops
  ];

  sops = {
    defaultSopsFile = lib.custom.relativeToRoot "secrets/secrets.sops.yaml";
    age.keyFile = "/var/lib/sops-nix/keys.txt";
    age.sshKeyPaths = [ ];
    gnupg.sshKeyPaths = [ ];
  };
}
