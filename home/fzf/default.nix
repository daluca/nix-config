{ pkgs, ... }:
let
  inherit (pkgs.unstable) fzf;
in {
  programs.fzf = {
    enable = true;
    package = fzf;
    enableBashIntegration = false;
    fileWidgetCommand = /* bash */ ''
      fd --type file
    '';
    changeDirWidgetCommand = /* bash */ ''
      fd --type directory
    '';
  };

  programs.fd.enable = true;
}
