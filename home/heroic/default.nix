{ lib, pkgs, ... }:
let
  inherit (lib) getOutput;
  inherit (pkgs.unstable) heroic;
  inherit (pkgs) ge-proton9-20 ge-proton9-19 ge-proton9-18 ge-proton9-17 ge-proton9-16 ge-proton9-15 ge-proton9-14 ge-proton9-13 ge-proton9-12 ge-proton9-11 ge-proton8-32 ge-proton7-55;
in {
  home.packages = [
    heroic
  ];

  xdg.configFile."heroic/tools/proton/GE-Proton9-20".source = getOutput "steamcompattool" ge-proton9-20;
  xdg.configFile."heroic/tools/proton/GE-Proton9-19".source = getOutput "steamcompattool" ge-proton9-19;
  xdg.configFile."heroic/tools/proton/GE-Proton9-18".source = getOutput "steamcompattool" ge-proton9-18;
  xdg.configFile."heroic/tools/proton/GE-Proton9-17".source = getOutput "steamcompattool" ge-proton9-17;
  xdg.configFile."heroic/tools/proton/GE-Proton9-16".source = getOutput "steamcompattool" ge-proton9-16;
  xdg.configFile."heroic/tools/proton/GE-Proton9-15".source = getOutput "steamcompattool" ge-proton9-15;
  xdg.configFile."heroic/tools/proton/GE-Proton9-14".source = getOutput "steamcompattool" ge-proton9-14;
  xdg.configFile."heroic/tools/proton/GE-Proton9-13".source = getOutput "steamcompattool" ge-proton9-13;
  xdg.configFile."heroic/tools/proton/GE-Proton9-12".source = getOutput "steamcompattool" ge-proton9-12;
  xdg.configFile."heroic/tools/proton/GE-Proton9-11".source = getOutput "steamcompattool" ge-proton9-11;
  xdg.configFile."heroic/tools/proton/GE-Proton8-32".source = getOutput "steamcompattool" ge-proton8-32;
  xdg.configFile."heroic/tools/proton/GE-Proton7-55".source = getOutput "steamcompattool" ge-proton7-55;
}
