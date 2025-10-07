{ config, ... }@args:
let
  secrets = args.secrets // builtins.fromTOML (builtins.readFile ../secrets.toml);
in {
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
      id = secrets.syncthing.RRS-A00690.id;
      address = [
        "tcp://10.200.100.85"
      ];
    };
  };
}
