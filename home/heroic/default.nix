{ lib, pkgs, ... }:
let
  inherit (lib) getOutput;
  inherit (pkgs.unstable) heroic;
  inherit (pkgs) GE-Proton9-24 GE-Proton9-23 GE-Proton9-22 GE-Proton9-21 GE-Proton9-20 GE-Proton9-19 GE-Proton8-32 GE-Proton7-55;
in {
  home.packages = [
    heroic
  ];

  xdg.configFile."heroic/tools/proton/GE-Proton9-18".source = getOutput "steamcompattool" GE-Proton9-24;
  xdg.configFile."heroic/tools/proton/GE-Proton9-23".source = getOutput "steamcompattool" GE-Proton9-23;
  xdg.configFile."heroic/tools/proton/GE-Proton9-22".source = getOutput "steamcompattool" GE-Proton9-22;
  xdg.configFile."heroic/tools/proton/GE-Proton9-21".source = getOutput "steamcompattool" GE-Proton9-21;
  xdg.configFile."heroic/tools/proton/GE-Proton9-20".source = getOutput "steamcompattool" GE-Proton9-20;
  xdg.configFile."heroic/tools/proton/GE-Proton9-19".source = getOutput "steamcompattool" GE-Proton9-19;
  xdg.configFile."heroic/tools/proton/GE-Proton8-32".source = getOutput "steamcompattool" GE-Proton8-32;
  xdg.configFile."heroic/tools/proton/GE-Proton7-55".source = getOutput "steamcompattool" GE-Proton7-55;
}
