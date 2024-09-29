{ config, lib, pkgs, ... }:
let
  inherit (pkgs) garden;
in {
  # TODO: Create garden options module
  home.packages = [
    garden
  ];

  programs.zsh.initExtra = lib.mkIf config.programs.zsh.enable /* bash */ /* zsh */ ''
    if [[ -x "$( command -v garden )" ]]; then
      eval "$(${garden}/bin/garden completion zsh)"
    fi
  '';
}
