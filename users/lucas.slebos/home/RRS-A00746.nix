{ config, lib, pkgs, ... }:

{
  host.battery = true;

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

  services.syncthing.settings = {
    folders = {
      "${config.home.homeDirectory}/Documents".devices = [
        "RRS-A00690"
      ];
    };
    devices.RRS-A00690 = {
      id = "7NYBZDL-ASE6YDX-YMUMTRV-QF6YD7Z-SJJEZZK-B2S2PVH-7L3SCW6-XXE4KQQ";
      address = [
        "tcp://10.200.100.85"
      ];
    };
  };
}
