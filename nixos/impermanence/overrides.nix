{ config, lib, ... }:

{
  boot.initrd.secrets = lib.mkIf config.boot.initrd.network.ssh.enable {
    "/etc/ssh/ssh_initrd_rsa_key" = lib.mkForce "/persistent/system/etc/ssh/ssh_initrd_rsa_key";
    "/etc/ssh/ssh_initrd_ed25519_key" = lib.mkForce "/persistent/system/etc/ssh/ssh_initrd_ed25519_key";
  };
}
