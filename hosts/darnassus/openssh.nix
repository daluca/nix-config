{ config, ... }:

{
  programs.ssh.knownHosts = rec {
    darnassus = {
      extraHostNames = [ "darnassus.${config.networking.domain}" "192.168.1.212" "100.64.0.14" ];
      publicKeyFile = ./keys/ssh_host_ed25519_key.pub;
    };
    "darnassus/rsa" = {
      hostNames = [ "darnassus" ] ++ darnassus.extraHostNames;
      publicKeyFile = ./keys/ssh_host_rsa_key.pub;
    };
  };
}
