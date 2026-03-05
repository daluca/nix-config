{ config, pkgs, ... }:

{
  programs.neovide = {
    enable = true;
    package = pkgs.unstable.neovide;
    settings = {
      font = let
        font = "Monaspace Krypton Var";
      in {
        normal = [font];
        size = 12;
        features.${font} = [
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
          "+ss10"
          "+liga"
        ];
      };
    };
  };

  xdg.mimeApps.defaultApplicationPackages = with config; [
    programs.neovide.package
  ];
}
