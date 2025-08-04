{ lib, ... }:

{
  sops.age = {
    keyFile = lib.mkForce "/persistent/system/var/lib/sops-nix/keys.txt";
    sshKeyPaths = lib.mkForce [
      "/persistent/system/etc/ssh/ssh_host_ed25519_key"
    ];
  };
}
