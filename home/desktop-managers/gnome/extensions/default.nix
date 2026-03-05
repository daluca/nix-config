{ lib, ... }:

{
  imports = [
    ./app-indicator.nix
    ./auto-cpufreq-switcher.nix
    ./caffeine.nix
    ./gsconnect
    ./in-picture.nix
    ./no-overview.nix
    ./paperwm.nix
    ./tailscale-qs.nix
  ];

  dconf.settings."org/gnome/shell" = {
    disable-user-extensions = false;
    disabled-extensions = lib.mkDefault [ ];
  };
}
