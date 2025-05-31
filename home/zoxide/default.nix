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

  home.sessionVariables = {
    _ZO_FZF_OPTS = "--tmux center,60%,border-native";
  };

  home.persistence.home.directories = [
    ".local/share/zoxide"
  ];
}
