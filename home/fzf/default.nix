{ pkgs, ... }:
let
  inherit (pkgs.unstable) fzf;
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

  programs.fd.enable = true;
}
