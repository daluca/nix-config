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
  };
}
