{ pkgs, ... }:

{
  home.packages = with pkgs; [
    opentofu
  ];

  programs.zsh.oh-my-zsh.plugins = [
    "opentofu"
  ];

  home.shellAliases = {
    tf = "tofu";
  };
}
