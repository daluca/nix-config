{ config, lib, ... }:

{
  programs.ssh = {
    knownHosts = rec {
      darnassus = {
        extraHostNames = [ "darnassus.${config.networking.domain}" "192.168.1.212" ];
        publicKeyFile = lib.custom.relativeToHosts "darnassus/keys/ssh_host_ed25519_key.pub";
      };
      "darnassus/rsa" = {
        hostNames = [ "darnassus" ] ++ darnassus.extraHostNames;
        publicKeyFile = lib.custom.relativeToHosts "darnassus/keys/ssh_host_rsa_key.pub";
      };
    };
    extraConfig = /* ssh */ ''
      Host darnassus
        HostName 192.168.1.212
        PubkeyAcceptedKeyTypes ssh-ed25519
        ServerAliveInterval 60
        IPQoS throughput
        IdentityFile /etc/ssh/ssh_host_ed25519_key
    '';
  };
}
