{ pkgs, ... }:

with pkgs.gnomeExtensions; {
  home.packages = [ auto-cpufreq-switcher ];

  dconf.settings."org/gnome/shell".enabled-extensions = [
    auto-cpufreq-switcher.extensionUuid
  ];
}
