{ config, ... }:

{
  programs.ssh.knownHosts = rec {
    stormwind = {
      extraHostNames = [ "stormwind.${config.networking.domain}" "192.168.178.10" ];
      publicKeyFile = ./keys/ssh_host_ed25519_key.pub;
    };
    "stormwind/rsa" = {
      hostNames = [ "stormwind" ] ++ stormwind.extraHostNames;
      publicKeyFile = ./keys/ssh_host_rsa_key.pub;
    };
  };
}
