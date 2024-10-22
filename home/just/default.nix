{ config, lib, pkgs, ... }:
let
  inherit (lib) mkIf;
  inherit (pkgs) just;
  inherit (config.programs) zsh;
in {
  home.packages = [
    just
  ];

  home.shellAliases = {
    j = "just";
  };

  home.sessionVariables = {
    JUST_COMMAND_COLOR = "blue";
  };

  programs.zsh.initExtra = mkIf zsh.enable /* zsh */ /* bash */ ''
    if [[ -x "$( command -v garden )" ]]; then
      eval "$(${pkgs.unstable.just}/bin/just --completions zsh)"
    fi
  '';
}
