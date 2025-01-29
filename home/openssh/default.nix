let
  zsh-login = {
    RemoteCommand = "zsh --login";
    RequestTTY = "force";
  };
in {
  programs.ssh = {
    enable = true;
    compression = true;
    hashKnownHosts = true;
    matchBlocks = {
      stormwind.extraOptions = zsh-login;
      ironforge.extraOptions = zsh-login;
      darnassus.extraOptions = zsh-login;
      azeroth.extraOptions = zsh-login;
    };
  };
}
