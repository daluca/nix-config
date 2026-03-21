{ config, secrets, ... }:

{
  programs.ssh.knownHosts = rec {
    delta = {
      extraHostNames = [ "delta.${config.networking.domain}" secrets.hosts.delta.ipv4-address ];
      publicKeyFile = ./keys/ssh_host_ed25519_key.pub;
    };
    "delta/rsa" = {
      hostNames = [ "delta" ] ++ delta.extraHostNames;
      publicKeyFile = ./keys/ssh_host_rsa_key.pub;
    };
    delta-initrd = {
      hostNames = [ "[delta]:22022" ] ++ delta-initrd.extraHostNames;
      extraHostNames = [ "[delta.${config.networking.domain}]:22022" "[${secrets.hosts.delta.ipv4-address}]:22022" ];
      publicKeyFile = ./keys/ssh_initrd_ed25519_key.pub;
    };
    "delta-initrd/rsa" = {
      hostNames = [ "[delta]:22022" ] ++ delta-initrd.extraHostNames;
      publicKeyFile = ./keys/ssh_initrd_rsa_key.pub;
    };
  };
}
