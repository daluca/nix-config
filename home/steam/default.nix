{ pkgs, ... }:

{
  imports = [
    ./mangohud.nix
  ];

  home.packages = with pkgs; [
    mangohud
  ];

  xdg.dataFile = with pkgs; {
    "Steam/compatibilitytools.d/GE-Proton11".source = lib.getOutput "steamcompattool" GE-Proton11;
    "Steam/compatibilitytools.d/GE-Proton11-1".source = lib.getOutput "steamcompattool" GE-Proton11-1;
    "Steam/compatibilitytools.d/GE-Proton10".source = lib.getOutput "steamcompattool" GE-Proton10;
    "Steam/compatibilitytools.d/GE-Proton10-34".source = lib.getOutput "steamcompattool" GE-Proton10-34;
    "Steam/compatibilitytools.d/GE-Proton10-33".source = lib.getOutput "steamcompattool" GE-Proton10-33;
    "Steam/compatibilitytools.d/GE-Proton10-32".source = lib.getOutput "steamcompattool" GE-Proton10-32;
    "Steam/compatibilitytools.d/GE-Proton10-31".source = lib.getOutput "steamcompattool" GE-Proton10-31;
    "Steam/compatibilitytools.d/GE-Proton10-30".source = lib.getOutput "steamcompattool" GE-Proton10-30;
    "Steam/compatibilitytools.d/GE-Proton9".source = lib.getOutput "steamcompattool" GE-Proton9;
    "Steam/compatibilitytools.d/GE-Proton8".source = lib.getOutput "steamcompattool" GE-Proton8;
    "Steam/compatibilitytools.d/GE-Proton7".source = lib.getOutput "steamcompattool" GE-Proton7;
  };

  home.persistence.home.directories = [
    ".local/share/Steam"
  ];
}
