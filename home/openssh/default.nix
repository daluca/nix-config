{ config, ... }:

{
  programs.ssh = {
    enable = true;
    compression = true;
    hashKnownHosts = true;
    matchBlocks."${config.home.username}" = {
      match = "User ${config.home.username}";
      extraOptions = {
        RemoteCommand = "zsh --login";
        RequestTTY = "yes";
      };
    };
  };
}
