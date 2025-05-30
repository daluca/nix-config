{ pkgs, ... }:

{
  programs.fzf = {
    enable = true;
    package = pkgs.unstable.fzf;
    enableBashIntegration = false;
    fileWidgetCommand = /* bash */ ''
      ${pkgs.unstable.fd}/bin/fd --type file
    '';
    changeDirWidgetCommand = /* bash */ ''
      ${pkgs.unstable.fd}/bin/fd --type directory
    '';
  };
}
