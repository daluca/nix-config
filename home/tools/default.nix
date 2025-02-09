{ pkgs, ... }:
let
  inherit (pkgs) jq yq-go curl wl-clipboard file unzip dig;
in {
  imports = [
    ../fzf
    ../gron
    ../zoxide
    ../delta
    ./ripgrep
  ];

  home.packages = [
    jq
    yq-go
    curl
    wl-clipboard
    file
    unzip
    dig
  ];
}
