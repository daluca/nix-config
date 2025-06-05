{
  programs.ssh.matchBlocks = {
    RRS-A00690 = {
      hostname = "10.200.100.85";
      extraOptions = {
        RemoteCommand = "zsh --login";
        RequestTTY = "yes";
      };
    };
  };

  programs.zsh.sessionVariables = {
    ZSH_TMUX_DEFAULT_SESSION_NAME = "RRS-A00746";
  };
}
