{ config, lib, ... }:
let
  inherit (lib) mkIf;
  inherit (config.services.xserver.desktopManager) gnome;
in {
  services.xserver.xkb = {
    layout = "us,us";
    variant = "dvorak,";
    options = mkIf (! gnome.enable) "grp:win_space_toggle";
  };

  console.useXkbConfig = true;
}
