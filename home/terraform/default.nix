{ pkgs, ... }:

{
  home.packages = with pkgs; [
    terraform
  ];

  programs.zsh.oh-my-zsh.plugins = [
    "terraform"
  ];
}
