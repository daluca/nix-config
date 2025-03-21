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

  home.persistence.home.directories = [
    ".ssh"
  ];
}
