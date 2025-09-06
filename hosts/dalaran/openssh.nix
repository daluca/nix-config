{ config, ... }:

{
  programs.ssh.knownHosts = rec {
    dalaran = {
      extraHostNames = [ "dalaran.${config.networking.domain}" "192.168.178.11" ];
      publicKeyFile = ./keys/ssh_host_ed25519_key.pub;
    };
    "dalaran/rsa" = {
      hostNames = [ "dalaran" ] ++ dalaran.extraHostNames;
      publicKeyFile = ./keys/ssh_host_rsa_key.pub;
    };
  };
}
