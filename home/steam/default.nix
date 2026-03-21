{ pkgs, ... }:

{
  imports = [
    ./mangohud.nix
  ];

  home.packages = with pkgs; [
    mangohud
  ];

  xdg.dataFile = with pkgs; {
    "Steam/compatibilitytools.d/GE-Proton10-34".source = lib.getOutput "steamcompattool" GE-Proton10-34;
    "Steam/compatibilitytools.d/GE-Proton10-33".source = lib.getOutput "steamcompattool" GE-Proton10-33;
    "Steam/compatibilitytools.d/GE-Proton10-32".source = lib.getOutput "steamcompattool" GE-Proton10-32;
    "Steam/compatibilitytools.d/GE-Proton10-31".source = lib.getOutput "steamcompattool" GE-Proton10-31;
    "Steam/compatibilitytools.d/GE-Proton10-30".source = lib.getOutput "steamcompattool" GE-Proton10-30;
    "Steam/compatibilitytools.d/GE-Proton9-27".source = lib.getOutput "steamcompattool" GE-Proton9-27;
    "Steam/compatibilitytools.d/GE-Proton8-32".source = lib.getOutput "steamcompattool" GE-Proton8-32;
    "Steam/compatibilitytools.d/GE-Proton7-55".source = lib.getOutput "steamcompattool" GE-Proton7-55;
  };

  home.persistence.home.directories = [
    ".local/share/Steam"
  ];
}
