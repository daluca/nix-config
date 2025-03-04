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

  sops.age = {
    sshKeyPaths = lib.mkForce [ "/persistent/system/etc/ssh/ssh_host_ed25519_key" ];
    keyFile = lib.mkForce "/persistent/system/var/lib/sops-nix/key.txt";
  };

  programs.zsh.history.path = lib.mkForce "${config.home.persistence.home.persistentStoragePath}/${config.programs.zsh.dotDir}/.zsh_history";
}
