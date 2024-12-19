{
  specialisation.gaming.configuration = {
    dconf.settings."org/gnome/desktop/input-sources" = mkIf gnome.enable {
      sources = mkForce [ ( mkTuple ["xkb" "us"] ) ( mkTuple ["xkb" "us+dvorak"] ) ];
    };
  };
}
