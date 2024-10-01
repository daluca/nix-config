{ inputs, ... }:

{
  imports = [
    inputs.sops-nix.homeManagerModules.sops
  ];

  sops = {
    defaultSopsFile = ../../secrets/secrets.sops.yaml;
    age = {
      sshKeyPaths = [
        "/persistent/system/etc/ssh/ssh_host_ed25519_key"
      ];
      keyFile = "/persistent/system/var/lib/sops-nix/key.txt";
      generateKey = true;
    };
  };
}
