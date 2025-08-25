{ config, lib, ... }:

{
  programs.ssh = {
    knownHosts = rec {
      stormwind = {
        extraHostNames = [ "storwind.${config.networking.domain}" "192.168.178.10" ];
        publicKeyFile = lib.custom.relativeToHosts "stormwind/keys/ssh_host_ed25519_key.pub";
      };
      "stormwind/rsa" = {
        hostNames = [ "stormwind" ] ++ stormwind.extraHostNames;
        publicKeyFile = lib.custom.relativeToHosts "stormwind/keys/ssh_host_rsa_key.pub";
      };
    };
    extraConfig = /* ssh */ ''
      Host stormwind
        HostName 192.168.178.10
    '';
  };
}
