{ lib, osConfig, ... }:
let
  inherit (lib) mkIf mkForce;
  inherit (lib.hm.gvariant) mkTuple;
  inherit (osConfig.services.xserver.desktopManager) gnome;
in {
  dconf.settings."org/gnome/desktop/input-sources" = mkIf gnome.enable {
    sources = [ ( mkTuple ["xkb" "us+dvorak"] ) ( mkTuple ["xkb" "us"] ) ];
  };
}
