{ ... }:

{
  imports = [
    ./app-indicator.nix
    ./gsconnect.nix
    ./caffeine.nix
    ./no-overview.nix
    ./tailscale-qs.nix
  ];

  dconf.settings."org/gnome/shell" = {
    disable-user-extensions = false;
    disabled-extensions = [ ];
  };
}
