{ config, lib, ... }:

{
  programs.ssh = {
    knownHosts = rec {
      ironforge = {
        extraHostNames = [ "ironforge.${config.networking.domain}" "192.168.1.10" ];
        publicKeyFile = lib.custom.relativeToHosts "ironforge/keys/ssh_host_ed25519_key.pub";
      };
      "ironforge/rsa" = {
        hostNames = [ "ironforge" ] ++ ironforge.extraHostNames;
        publicKeyFile = lib.custom.relativeToHosts "ironforge/keys/ssh_host_rsa_key.pub";
      };
    };
    extraConfig = /* ssh */ ''
      Host ironforge
        HostName 192.168.1.10
    '';
  };
}
