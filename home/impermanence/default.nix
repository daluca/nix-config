{ config, ... }:

{
  home.persistence.home = {
    enable = true;
    persistentStoragePath = "/persistent/home/${config.home.username}";
    allowOther = true;
    directories = [
      ".local/share/keyrings"
    ];
  };

  programs.zsh.history.path = "/persistent" + "${config.xdg.dataHome}/zsh/zsh_history";
}
