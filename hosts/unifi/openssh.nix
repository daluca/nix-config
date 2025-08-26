{ config, secrets, ... }:

{
  programs.ssh.knownHosts = rec {
    unifi = {
      extraHostNames = [ "unifi.${config.networking.domain}" secrets.hosts.unifi.ipv4-address ];
      publicKeyFile = ./keys/ssh_host_ed25519_key.pub;
    };
    "unifi/rsa" = {
      hostNames = [ "unifi" ] ++ unifi.extraHostNames;
      publicKeyFile = ./keys/ssh_host_rsa_key.pub;
    };
  };
}
