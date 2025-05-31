{ config, lib, pkgs, ... }:

{
  programs.fzf = {
    enable = true;
    enableBashIntegration = false;
    defaultCommand = "${config.programs.fd.package}/bin/fd --type file";
    defaultOptions = [
      "--tmux center,60%,border-native"
    ];
    fileWidgetCommand = "${config.programs.fd.package}/bin/fd --type file";
    fileWidgetOptions = [
      "--preview '${lib.getExe pkgs.fzf-preview} {}'"
      "--tmux center,80%,border-native"
      "--select-1"
      "--exit-0"
    ];
    changeDirWidgetCommand = "${config.programs.fd.package}/bin/fd --type directory";
    changeDirWidgetOptions = [
      "--preview '${pkgs.tree}/bin/tree -C {}'"
      "--tmux center,80%,border-native"
      "--select-1"
      "--exit-0"
    ];
  };

  catppuccin.fzf.enable = true;
}
