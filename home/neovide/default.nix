{ config, lib, pkgs, ... }:

{
  home.packages = with pkgs.unstable; [ neovide ];

  xdg.configFile."neovide/config.toml".source = ./config.toml;

  programs.zsh.shellAliases = lib.mkIf config.programs.zsh.enable { nv = "neovide"; };
}
