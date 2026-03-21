{ lib, pkgs, ... }:

{
  home.packages = with pkgs.unstable; [
    heroic
  ];

  xdg.configFile = with pkgs; {
    "heroic/tools/proton/GE-Proton10-34".source = lib.getOutput "steamcompattool" GE-Proton10-34;
    "heroic/tools/proton/GE-Proton10-33".source = lib.getOutput "steamcompattool" GE-Proton10-33;
    "heroic/tools/proton/GE-Proton10-32".source = lib.getOutput "steamcompattool" GE-Proton10-32;
    "heroic/tools/proton/GE-Proton10-31".source = lib.getOutput "steamcompattool" GE-Proton10-31;
    "heroic/tools/proton/GE-Proton10-30".source = lib.getOutput "steamcompattool" GE-Proton10-30;
    "heroic/tools/proton/GE-Proton9-27".source = lib.getOutput "steamcompattool" GE-Proton9-27;
    "heroic/tools/proton/GE-Proton8-32".source = lib.getOutput "steamcompattool" GE-Proton8-32;
    "heroic/tools/proton/GE-Proton7-55".source = lib.getOutput "steamcompattool" GE-Proton7-55;
  };


  home.persistence.home.directories = [
    ".config/heroic"
    ".local/share/Heroic"
  ];
}
