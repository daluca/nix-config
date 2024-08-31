{ lib, osConfig, ... }:

{
  dconf.settings."org/gnome/desktop/input-sources" = with lib.hm.gvariant; lib.mkIf osConfig.services.xserver.desktopManager.gnome.enable {
    sources = [ ( mkTuple ["xkb" "us"] ) ( mkTuple ["xkb" "us+dvorak"] ) ];
  };
}
