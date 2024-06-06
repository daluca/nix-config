{ config, ... }:

{
  imports = [ ./gsconnect.nix ];

  dconf.settings."org/gnome/shell" = {
    disable-user-extensions = false;
    disabled-extensions = [ ];
    enabled-extensions = [ ];
  };
}
