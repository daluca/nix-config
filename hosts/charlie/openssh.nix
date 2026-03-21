{ config, secrets, ... }:

{
  programs.ssh.knownHosts = rec {
    charlie = {
      extraHostNames = [ "charlie.${config.networking.domain}" secrets.hosts.charlie.ipv4-address ];
      publicKeyFile = ./keys/ssh_host_ed25519_key.pub;
    };
    "charlie/rsa" = {
      hostNames = [ "charlie" ] ++ charlie.extraHostNames;
      publicKeyFile = ./keys/ssh_host_rsa_key.pub;
    };
    charlie-initrd = {
      hostNames = [ "[charlie]:22022" ] ++ charlie-initrd.extraHostNames;
      extraHostNames = [ "[charlie.${config.networking.domain}]:22022" "[${secrets.hosts.charlie.ipv4-address}]:22022" ];
      publicKeyFile = ./keys/ssh_initrd_ed25519_key.pub;
    };
    "charlie-initrd/rsa" = {
      hostNames = [ "[charlie]:22022" ] ++ charlie-initrd.extraHostNames;
      publicKeyFile = ./keys/ssh_initrd_rsa_key.pub;
    };
  };
}
