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
      gainas.hostname = "10.2.161.172";
      stormwind.hostname = "10.0.0.10";
      stormwind.extraOptions = zsh-login;
      ironforge.hostname = "192.168.1.232";
      ironforge.extraOptions = zsh-login;
      darnassus.hostname = "10.2.74.60";
      darnassus.extraOptions = zsh-login;
      azeroth.hostname = "10.1.219.30";
      azeroth.extraOptions = zsh-login;
    };
  };
}
