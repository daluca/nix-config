{ lib, osConfig, ... }:
let
  inherit (lib) mkForce mkIf;
  inherit (lib.hm.gvariant) mkTuple;
  inherit (osConfig.services.xserver.desktopManager) gnome;
in {
  specialisation.gaming.configuration = {
    dconf.settings."org/gnome/desktop/input-sources" = mkIf gnome.enable {
      sources = mkForce [ ( mkTuple ["xkb" "us"] ) ( mkTuple ["xkb" "us+dvorak"] ) ];
    };
  };
}
