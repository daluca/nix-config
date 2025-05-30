{ pkgs, ... }:

{
  home.packages = with pkgs.unstable; [
    just
  ];

  home.shellAliases = {
    j = "just";
  };

  home.sessionVariables = {
    JUST_COMMAND_COLOR = "blue";
  };

  programs.zsh.initContent = /* zsh */ /* bash */ ''
    if [[ -x "$( command -v garden )" ]]; then
      eval "$(${pkgs.unstable.just}/bin/just --completions zsh)"
    fi
  '';
}
