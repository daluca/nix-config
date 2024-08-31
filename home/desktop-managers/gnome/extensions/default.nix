{ ... }:

{
  imports = [
    ./app-indicator.nix
    ./gsconnect.nix
    ./caffeine.nix
    ./no-overview.nix
  ];

  dconf.settings."org/gnome/shell" = {
    disable-user-extensions = false;
    disabled-extensions = [ ];
  };
}
