{ pkgs, ... }:

{
  imports = [
    ../fzf
    ../gron
  ];

  home.packages = with pkgs; [
    jq
    yq-go
    curl
    wl-clipboard
    file
    unzip
    dig
  ];
}
