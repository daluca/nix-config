{ config, secrets, ... }:

{
  programs.ssh.knownHosts = rec {
    bravo = {
      extraHostNames = [ "bravo.${config.networking.domain}" secrets.hosts.bravo.ipv4-address ];
      publicKeyFile = ./keys/ssh_host_ed25519_key.pub;
    };
    "bravo/rsa" = {
      hostNames = [ "bravo" ] ++ bravo.extraHostNames;
      publicKeyFile = ./keys/ssh_host_rsa_key.pub;
    };
    bravo-initrd = {
      hostNames = [ "[bravo]:22022" ] ++ bravo-initrd.extraHostNames;
      extraHostNames = [ "[bravo.${config.networking.domain}]:22022" "[${secrets.hosts.bravo.ipv4-address}]:22022" ];
      publicKeyFile = ./keys/ssh_initrd_ed25519_key.pub;
    };
    "bravo-initrd/rsa" = {
      hostNames = [ "[bravo]:22022" ] ++ bravo-initrd.extraHostNames;
      publicKeyFile = ./keys/ssh_initrd_rsa_key.pub;
    };
  };
}
