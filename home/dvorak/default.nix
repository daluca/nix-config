{ config, lib, ... }:

{
  dconf.settings = with lib.hm.gvariant; {
    "org/gnome/desktop/input-sources" = {
      sources = [ ( mkTuple [ "xkb" "us+dvorak" ] ) ( mkTuple [ "xkb" "us" ] ) ];
    };
  };
}