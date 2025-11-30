{ lib, ... }:

{
  specialisation.gaming.configuration = {
    dconf.settings."org/gnome/desktop/input-sources" = with lib.hm.gvariant; {
      sources = mkForce [ ( mkTuple ["xkb" "us"] ) ( mkTuple ["xkb" "us+dvorak"] ) ];
    };
  };
}
