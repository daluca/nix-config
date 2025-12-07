{ config, ... }:

{
  programs.ssh.knownHosts = rec {
    homeassistant = {
      extraHostNames = [ "homeassistant.${config.networking.domain}" "192.168.178.12" ];
      publicKeyFile = ./keys/ssh_host_ed25519_key.pub;
    };
    "homeassistant/rsa" = {
      hostNames = [ "homeassistant" ] ++ homeassistant.extraHostNames;
      publicKeyFile = ./keys/ssh_host_rsa_key.pub;
    };
  };
}
