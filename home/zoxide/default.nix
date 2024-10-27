{ pkgs, ... }:
let
  inherit (pkgs.unstable) zoxide;
in {
  programs.zoxide = {
    enable = true;
    package = zoxide;
    enableBashIntegration = false;
    options = [
      "--cmd=cd"
    ];
  };

  programs.fzf.enable = true;
}
