{ config, lib, system, inputs, ... }:
let
  garden = inputs.garden.packages.${system}.default;
in {
  # TODO: Create gardes options module
  home.packages = [
    garden
  ];

  programs.zsh.initExtra = lib.mkIf config.programs.zsh.enable /* zsh */ ''
    if [[ -x "$( command -v garden )" ]]; then
      eval "$(${garden}/bin/garden completion zsh)"
    fi
  '';
}
