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
  };
}
