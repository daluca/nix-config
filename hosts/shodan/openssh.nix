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
    shodan-initrd = {
      hostNames = [ "[shodan]:22022" ] ++ shodan-initrd.extraHostNames;
      extraHostNames = [ "[shodan.${config.networking.domain}]:22022" "[${secrets.hosts.shodan.ipv4-address}]:22022" ];
      publicKeyFile = ./keys/ssh_initrd_ed25519_key.pub;
    };
    "shodan-initrd/rsa" = {
      hostNames = [ "[shodan]:22022" ] ++ shodan-initrd.extraHostNames;
      publicKeyFile = ./keys/ssh_initrd_rsa_key.pub;
    };
  };
}
