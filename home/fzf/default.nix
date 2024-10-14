{ pkgs, ... }:
let
  inherit (pkgs) fzf fd;
in {
  programs.fzf = {
    enable = true;
    package = fzf;
    enableBashIntegration = false;
    fileWidgetCommand = ''
      fd --type file
    '';
    changeDirWidgetCommand = ''
      fd --type directory
    '';
  };

  # TODO: Conditionally add fd if not already added
  home.packages = [
    fd
  ];
}
