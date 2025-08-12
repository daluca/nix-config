{ lib, ... }:

{
  sops = {
    age.keyFile = lib.mkForce "/persistent/system/var/lib/sops-nix/keys.txt";
    age.sshKeyPaths = [
      "/persistent/system/etc/ssh/ssh_host_ed25519_key"
    ];
    gnupg.sshKeyPaths = [
      "/persistent/system/etc/ssh/ssh_host_rsa_key"
    ];
  };
}
