{ lib, pkgs, ... }:

{
  home.packages = with pkgs.unstable; [
    heroic
  ];

  xdg.configFile = with pkgs; {
    "heroic/tools/proton/GE-Proton10-1".source = lib.getOutput "steamcompattool" GE-Proton10-1;
    "heroic/tools/proton/GE-Proton9-27".source = lib.getOutput "steamcompattool" GE-Proton9-27;
    "heroic/tools/proton/GE-Proton9-26".source = lib.getOutput "steamcompattool" GE-Proton9-26;
    "heroic/tools/proton/GE-Proton9-25".source = lib.getOutput "steamcompattool" GE-Proton9-25;
    "heroic/tools/proton/GE-Proton9-24".source = lib.getOutput "steamcompattool" GE-Proton9-24;
    "heroic/tools/proton/GE-Proton9-23".source = lib.getOutput "steamcompattool" GE-Proton9-23;
    "heroic/tools/proton/GE-Proton8-32".source = lib.getOutput "steamcompattool" GE-Proton8-32;
    "heroic/tools/proton/GE-Proton7-55".source = lib.getOutput "steamcompattool" GE-Proton7-55;
  };


  home.persistence.home.directories = [
    ".config/heroic"
    ".local/share/Heroic"
  ];
}
