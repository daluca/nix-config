{ config, lib, pkgs, osConfig, ... }:

{
  home.packages = with pkgs.unstable; [
    velero
  ];

  home.persistence.home.directories = lib.mkIf osConfig.environment.persistence.system.enable [
    ".config/velero"
  ];

  xdg.configFile."velero/config.json".text = builtins.toJSON {
    namespace = "backups";
  };

  programs.zsh.initExtra = lib.mkIf config.programs.zsh.enable /* zsh */ ''
    if [[ -x "$( command -v velero )" ]]; then
      eval "$(${pkgs.unstable.velero}/bin/velero completion zsh)"
    fi
  '';
}
