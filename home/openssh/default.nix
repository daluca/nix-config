{ config, lib, secrets, ... }:

{
  programs.ssh = {
    enable = true;
    compression = true;
    hashKnownHosts = true;
    matchBlocks = {
      ${config.home.username} = {
        match = "User ${config.home.username} Host *,!${lib.concatStringsSep ",!" [
          "192.168.1.1"
          "192.168.1.2"
          "192.168.1.3"
          "192.168.1.4"
        ]}";
        extraOptions = {
          RemoteCommand = "zsh --login";
          RequestTTY = "yes";
        };
      };
      usg = {
        host = "192.168.1.1";
        extraOptions = {
          PubkeyAcceptedKeyTypes = "+ssh-rsa";
        };
      };
      stormwind.hostname = "192.168.178.10";
      darnassus.hostname = "192.168.1.212";
      ironforge.hostname = "192.168.1.10";
      guiltyspark.hostname = "192.168.1.21";
      unifi.hostname = secrets.hosts.unifi.ipv4-address;
      alfa.hostname = secrets.hosts.alfa.ipv4-address;
    };
  };

  sops.secrets."id_ed25519" = {
    sopsFile = lib.custom.relativeToUsers "${config.home.username}/${config.home.username}.sops.yaml";
    path = ".ssh/id_ed25519";
  };

  home.file.".ssh/id_ed25519.pub".source = lib.custom.relativeToUsers "${config.home.username}/keys/id_ed25519.pub";

  home.persistence.home.directories = [
    ".ssh"
  ];
}
