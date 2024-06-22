{ config, lib, ... }:

{
  imports = [ ./nixvim.nix ];

  programs.zsh.shellAliases = lib.mkIf config.programs.zsh.enable { n = "nvim"; };
}
