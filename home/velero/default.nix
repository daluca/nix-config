{ pkgs, ... }:

{
  home.packages = with pkgs.unstable; [
    velero
  ];

  home.persistence.home.directories = [
    ".config/velero"
  ];

  xdg.configFile."velero/config.json".text = builtins.toJSON {
    namespace = "backups";
  };

  programs.zsh.initContent = /* zsh */ ''
    if [[ -x "$( command -v velero )" ]]; then
      eval "$(${pkgs.unstable.velero}/bin/velero completion zsh)"
    fi
  '';
}
