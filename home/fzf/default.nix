{ pkgs, ... }:

{
  programs.fzf = {
    enable = true;
    package = pkgs.unstable.fzf;
    enableBashIntegration = false;
    fileWidgetCommand = ''
      fd --type file
    '';
    changeDirWidgetCommand = ''
      fd --type directory
    '';
  };

  # TODO: Conditionally add fd if not already added
  home.packages = with pkgs.unstable; [
    fd
  ];
}
