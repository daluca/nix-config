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
    };
  };
}
