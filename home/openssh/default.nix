{
  programs.ssh = {
    enable = true;
    compression = true;
    hashKnownHosts = true;
    extraOptionOverrides = {
      RemoteCommand = "zsh --login";
      RequestTTY = "force";
    };
    matchBlocks = {
      gainas.hostname = "10.2.161.172";
      stormwind.hostname = "10.0.0.10";
    };
  };
}
