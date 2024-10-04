{ pkgs, ... }:
let
  inherit (pkgs) mangohud;
in {
  home.packages = [
    mangohud
  ];

  xdg.configFile."MangoHud/MangoHud.conf".text = ''
    no_display
  '';

  xdg.configFile."MangoHud/wine-Cyberpunk2077.conf".text = ''
    preset=1
    position=top-right
    no_display
  '';
}
