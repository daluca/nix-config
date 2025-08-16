{
  imports = [
    ./app-indicator.nix
    ./auto-cpufreq-switcher.nix
    ./caffeine.nix
    ./gsconnect
    ./no-overview.nix
    ./tailscale-qs.nix
  ];

  dconf.settings."org/gnome/shell" = {
    disable-user-extensions = false;
    disabled-extensions = [ ];
  };
}
