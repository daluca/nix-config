{ pkgs, ... }:

{
  imports = [
    ../fzf
    ../gron
    ../zoxide
    ../delta
    ./jq.nix
  ];

  home.packages = with pkgs; [
    yq-go
    curl
    wl-clipboard
    file
    unzip
    dig
  ];
}
