{ config, secrets, ... }:

{
  programs.ssh.knownHosts = rec {
    shodan = {
      extraHostNames = with secrets.hosts.shodan; [
        "shodan.${config.networking.domain}"
        ipv4-address
        tailscale-address
      ];
      publicKeyFile = ./keys/ssh_host_ed25519_key.pub;
    };
    "shodan/rsa" = {
      hostNames = [ "shodan" ] ++ shodan.extraHostNames;
      publicKeyFile = ./keys/ssh_host_rsa_key.pub;
    };
  };
}
