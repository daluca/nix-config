{ lib, pkgs, ... }:
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

  home.sessionVariables = {
    _ZO_FZF_OPTS = lib.concatStringsSep " " [
      "--preview '${pkgs.tree}/bin/tree -C {}'"
      "--tmux center,80%,border-native"
      "--select-1"
      "--exit-0"
    ];
  };

  home.persistence.home.directories = [
    ".local/share/zoxide"
  ];
}
