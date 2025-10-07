{ config, ... }@args:
let
  secrets = args.secrets // builtins.fromTOML (builtins.readFile ../secrets.toml);
in {
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
      id = secrets.syncthing.RRS-A00746.id;
      address = [
        "tcp://10.200.105.58"
      ];
    };
  };
}
