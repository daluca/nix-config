{ pkgs, ... }:

{
  imports = [
    ../fzf
    ../gron
    ../zoxide
    ../delta
    ./jq.nix
    ./comma.nix
  ];

  home.packages = with pkgs; [
    yq-go
    curl
    wl-clipboard
    file
    unzip
    dig
    tree
    entr
    toml-cli
  ];
}
