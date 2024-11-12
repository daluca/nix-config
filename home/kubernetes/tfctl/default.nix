{ pkgs, ... }:
let
  inherit (pkgs) tfctl;
in {
  home.packages = [
    tfctl
  ];

  programs.zsh.initExtra = /* zsh */ /* bash */ ''
    eval "$(${tfctl}/bin/tfctl completion zsh)"; compdef _tfctl tfctl
  '';
}
