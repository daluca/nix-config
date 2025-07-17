{ config, ... }:

{
  programs.zsh.sessionVariables = {
    ZSH_TMUX_DEFAULT_SESSION_NAME = "RRS-A00690";
  };

  services.syncthing.settings = {
    folders = {
      "${config.home.homeDirectory}/Documents".devices = [
        "RRS-A00746"
      ];
    };
    devices.RRS-A00746 = {
      id = "N23RY5M-BUHNUFC-YJZGTEW-POG4QVW-JDUNK52-XP5MPJY-WEVJDZG-5D77DA5";
      address = [
        "dynamic"
        "tcp://10.200.105.58"
      ];
    };
  };
}
