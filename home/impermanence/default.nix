{ config, lib, ... }:

{
  home.persistence.home = {
    enable = true;
    persistentStoragePath = "/persistent/home/${config.home.username}";
    allowOther = true;
    directories = [
      ".local/share/keyrings"
    ];
  };

  programs.zsh.history.path = lib.mkForce ("/persistent" + "${config.xdg.dataHome}/zsh/history");
}
