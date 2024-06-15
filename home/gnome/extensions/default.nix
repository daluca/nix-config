{ config, ... }:

{
  imports = [
    ./gsconnect.nix
    ./caffeine.nix
  ];

  dconf.settings."org/gnome/shell" = {
    disable-user-extensions = false;
    disabled-extensions = [ ];
  };
}
