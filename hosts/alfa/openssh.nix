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
  };
}
