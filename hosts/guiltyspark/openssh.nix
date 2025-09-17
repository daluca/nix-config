{ config, ... }:

{
  programs.ssh.knownHosts = rec {
    guiltyspark = {
      extraHostNames = [ "guiltyspark.${config.networking.domain}" "192.168.10.20" "100.64.0.10" ];
      publicKeyFile = ./keys/ssh_host_ed25519_key.pub;
    };
    "guiltyspark/rsa" = {
      hostNames = [ "guiltyspark" ] ++ guiltyspark.extraHostNames;
      publicKeyFile = ./keys/ssh_host_rsa_key.pub;
    };
  };
}
