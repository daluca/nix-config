{ pkgs, ... }:

{
  home.packages = with pkgs; [
    jq
  ];

  programs.zsh.plugins = with pkgs; [{
    inherit (jq-zsh-plugin) src;
    name = "jq";
  }];
}
