{ config, ... }:

{
  programs.ssh = {
    enable = true;
    compression = true;
    hashKnownHosts = true;
    matchBlocks."${config.home.username}" = {
      match = "User ${config.home.username} Host *,!gainas";
      extraOptions = {
        RemoteCommand = "zsh --login";
        RequestTTY = "yes";
      };
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
