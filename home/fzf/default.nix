{ config, lib, pkgs, ... }:

{
  programs.fzf = {
    enable = true;
    enableBashIntegration = false;
    defaultCommand = "${lib.getExe config.programs.fd.package} --type file";
    defaultOptions = [
      "--style full"
      "--tmux center,60%,border-native"
    ];
    fileWidgetCommand = "${lib.getExe config.programs.fd.package} --type file";
    fileWidgetOptions = [
      "--preview '${lib.getExe pkgs.fzf-preview} {}'"
      "--bind 'focus:transform-header:${lib.getExe pkgs.file} --brief {}'"
      "--tmux center,80%,border-native"
      "--exit-0"
    ];
    changeDirWidgetCommand = "${lib.getExe config.programs.fd.package} --type directory";
    changeDirWidgetOptions = [
      "--preview '${lib.getExe pkgs.tree} -C {}'"
      "--tmux center,80%,border-native"
      "--select-1"
      "--exit-0"
    ];
  };

  catppuccin.fzf.enable = true;
}
