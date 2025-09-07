{ config, ... }:

{
  programs.ssh.knownHosts = rec {
    ironforge = {
      extraHostNames = [ "ironforge.${config.networking.domain}" "192.168.1.10" "100.64.0.2" ];
      publicKeyFile = ./keys/ssh_host_ed25519_key.pub;
    };
    "ironforge/rsa" = {
      hostNames = [ "ironforge" ] ++ ironforge.extraHostNames;
      publicKeyFile = ./keys/ssh_host_rsa_key.pub;
    };
  };
}
