{ config, lib, secrets, ... }:

{
  programs.ssh = {
    knownHosts = rec {
      bravo = {
        extraHostNames = [ "bravo.${config.networking.domain}" secrets.hosts.bravo.ipv4-address ];
        publicKeyFile = lib.custom.relativeToHosts "bravo/keys/ssh_host_ed25519_key.pub";
      };
      "bravo/rsa" = {
        hostNames = [ "bravo" ] ++ bravo.extraHostNames;
        publicKeyFile = lib.custom.relativeToHosts "bravo/keys/ssh_host_rsa_key.pub";
      };
    };
    extraConfig = /* ssh */ ''
      Host bravo
        HostName ${secrets.hosts.bravo.ipv4-address}
    '';
  };
}
