{ config, lib, ... }:

{
  programs.ghostty = {
    enable = true;
    enableZshIntegration = true;
    settings = {
      command = lib.getExe config.programs.zsh.package;
      font-size = 11.5;
      font-family = [
        "Monaspace Krypton Var"
        "Symbols Nerd Font"
      ];
      font-feature = [
        "calt"
        "ss01"
        "ss02"
        "ss03"
        "ss04"
        "ss05"
        "ss06"
        "ss07"
        "ss08"
        "ss09"
        "ss10"
        "liga"
      ];
      bell-features = lib.concatStringsSep "," [
        "no-title"
      ];
      app-notifications = lib.concatStringsSep "," [
        "no-clipboard-copy"
      ];
    };
  };

  catppuccin.ghostty.enable = true;
}
