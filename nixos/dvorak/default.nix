{ config, lib, ... }:
let
  inherit (config.services.xserver.desktopManager) gnome;
in {
  services.xserver.xkb = {
    layout = "us,us";
    variant = "dvorak,";
    options = lib.mkIf (!gnome.enable) "grp:win_space_toggle";
  };

  console.useXkbConfig = true;
}
