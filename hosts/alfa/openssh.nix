{ config, lib, secrets, ... }:

{
  programs.ssh = {
    knownHosts = rec {
      alfa = {
        extraHostNames = [ "alfa.${config.networking.domain}" secrets.hosts.alfa.ipv4-address ];
        publicKeyFile = lib.custom.relativeToHosts "alfa/keys/ssh_host_ed25519_key.pub";
      };
      "alfa/rsa" = {
        hostNames = [ "alfa" ] ++ alfa.extraHostNames;
        publicKeyFile = lib.custom.relativeToHosts "alfa/keys/ssh_host_rsa_key.pub";
      };
    };
    extraConfig = /* ssh */ ''
      Host alfa
        HostName ${secrets.hosts.alfa.ipv4-address}
        PubkeyAcceptedKeyTypes ssh-ed25519
        ServerAliveInterval 60
        IPQoS throughput
        IdentityFile /etc/ssh/ssh_host_ed25519_key
    '';
  };
}
