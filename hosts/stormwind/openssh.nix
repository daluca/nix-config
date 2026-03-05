{ config, ... }:

{
  programs.ssh.knownHosts = rec {
    stormwind = {
      extraHostNames = [ "stormwind.${config.networking.domain}" "10.1.1.10" ];
      publicKeyFile = ./keys/ssh_host_ed25519_key.pub;
    };
    "stormwind/rsa" = {
      hostNames = [ "stormwind" ] ++ stormwind.extraHostNames;
      publicKeyFile = ./keys/ssh_host_rsa_key.pub;
    };
  };
}
