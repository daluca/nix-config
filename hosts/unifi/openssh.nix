{ config, lib, secrets, ... }:

{
  programs.ssh = {
    knownHosts = rec {
      unifi = {
        extraHostNames = [ "unifi.${config.networking.domain}" secrets.hosts.unifi.ipv4-address ];
        publicKeyFile = lib.custom.relativeToHosts "unifi/keys/ssh_host_ed25519_key.pub";
      };
      "unifi/rsa" = {
        hostNames = [ "unifi" ] ++ unifi.extraHostNames;
        publicKeyFile = lib.custom.relativeToHosts "unifi/keys/ssh_host_rsa_key.pub";
      };
    };
    extraConfig = /* ssh */ ''
      Host unifi
        HostName ${secrets.hosts.unifi.ipv4-address}
    '';
  };
}
