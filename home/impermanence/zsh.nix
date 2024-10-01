{ config, lib, ... }:
let
  inherit (lib) mkForce;
in {
  programs.zsh.history.path = mkForce "${config.home.persistence.home.persistentStoragePath}/${config.programs.zsh.dotDir}/.zsh_history";
}
