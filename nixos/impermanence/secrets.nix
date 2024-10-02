{ lib, ... }:
let
  inherit (lib) mkForce;
in {
  sops.age = {
    sshKeyPaths = mkForce [ "/persistent/system/etc/ssh/ssh_host_ed25519_key" ];
    keyFile = mkForce "/persistent/system/var/lib/sops-nix/key.txt";
  };
}
