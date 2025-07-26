{ lib, pkgs, ... }:

{
  home.packages = with pkgs.unstable; [
    heroic
  ];

  xdg.configFile = with pkgs; {
    "heroic/tools/proton/GE-Proton10-10".source = lib.getOutput "steamcompattool" GE-Proton10-10;
    "heroic/tools/proton/GE-Proton10-9".source = lib.getOutput "steamcompattool" GE-Proton10-9;
    "heroic/tools/proton/GE-Proton10-8".source = lib.getOutput "steamcompattool" GE-Proton10-8;
    "heroic/tools/proton/GE-Proton10-7".source = lib.getOutput "steamcompattool" GE-Proton10-7;
    "heroic/tools/proton/GE-Proton10-6".source = lib.getOutput "steamcompattool" GE-Proton10-6;
    "heroic/tools/proton/GE-Proton10-4".source = lib.getOutput "steamcompattool" GE-Proton10-4;
    "heroic/tools/proton/GE-Proton9-27".source = lib.getOutput "steamcompattool" GE-Proton9-27;
    "heroic/tools/proton/GE-Proton8-32".source = lib.getOutput "steamcompattool" GE-Proton8-32;
    "heroic/tools/proton/GE-Proton7-55".source = lib.getOutput "steamcompattool" GE-Proton7-55;
  };


  home.persistence.home.directories = [
    ".config/heroic"
    ".local/share/Heroic"
  ];
}
