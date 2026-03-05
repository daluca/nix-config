{ config, secrets, ... }:

{
  programs.ssh.knownHosts = rec {
    alfa = {
      extraHostNames = [ "alfa.${config.networking.domain}" secrets.hosts.alfa.ipv4-address ];
      publicKeyFile = ./keys/ssh_host_ed25519_key.pub;
    };
    "alfa/rsa" = {
      hostNames = [ "alfa" ] ++ alfa.extraHostNames;
      publicKeyFile = ./keys/ssh_host_rsa_key.pub;
    };
    alfa-initrd = {
      hostNames = [ "[alfa]:22022" ] ++ alfa-initrd.extraHostNames;
      extraHostNames = [ "[alfa.${config.networking.domain}]:22022" "[${secrets.hosts.alfa.ipv4-address}]:22022" ];
      publicKeyFile = ./keys/ssh_initrd_ed25519_key.pub;
    };
    "alfa-initrd/rsa" = {
      hostNames = [ "[alfa]:22022" ] ++ alfa-initrd.extraHostNames;
      publicKeyFile = ./keys/ssh_initrd_rsa_key.pub;
    };
  };
}
