{ pkgs, ... }:
let
  inherit (pkgs) tfctl;
in {
  home.packages = [
    tfctl
  ];

  programs.zsh.initContent = /* zsh */ /* bash */ ''
    eval "$(${tfctl}/bin/tfctl completion zsh)"; compdef _tfctl tfctl
  '';
}
