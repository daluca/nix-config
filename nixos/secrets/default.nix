{ lib, inputs, ... }:

{
  imports = [
    inputs.sops-nix.nixosModules.sops
  ];

  sops = {
    defaultSopsFile = lib.custom.relativeToRoot "secrets/secrets.sops.yaml";
    age.keyFile = "/var/lib/sops-nix/key.txt";
    age.sshKeyPaths = [
      "/etc/ssh/ssh_host_ed25519_key"
    ];
  };
}
