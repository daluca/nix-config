{ config, lib, ... }:

{
  programs.ssh = {
    knownHosts = rec {
      guiltyspark = {
        extraHostNames = [ "guiltyspark.${config.networking.domain}" "192.168.1.21" ];
        publicKeyFile = lib.custom.relativeToHosts "guiltyspark/keys/ssh_host_ed25519_key.pub";
      };
      "guiltyspark/rsa" = {
        hostNames = [ "guiltyspark" ] ++ guiltyspark.extraHostNames;
        publicKeyFile = lib.custom.relativeToHosts "guiltyspark/keys/ssh_host_rsa_key.pub";
      };
    };
    extraConfig = /* ssh */ ''
      Host guiltyspark
        HostName 192.168.1.21
        PubkeyAcceptedKeyTypes ssh-ed25519
        ServerAliveInterval 60
        IPQoS throughput
        IdentityFile /etc/ssh/ssh_host_ed25519_key
    '';
  };
}
