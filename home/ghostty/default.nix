{ config, lib, ... }:

{
  programs.ghostty = {
    enable = true;
    enableZshIntegration = true;
    settings = let
      font = "Monaspace Krypton Var";
    in {
      command = lib.getExe config.programs.zsh.package;
      font-size = 11;
      font-family = font;
      font-family-bold = font;
      font-family-italic = font;
      font-family-bold-italic = font;
      font-feature = [
        "+calt"
        "+ss01"
        "+ss02"
        "+ss03"
        "+ss04"
        "+ss05"
        "+ss06"
        "+ss07"
        "+ss08"
        "+ss09"
        "+liga"
      ];
    };
  };

  catppuccin.ghostty.enable = true;
}
