{ config, lib, pkgs, ... }:
let
  inherit (lib) mkIf;
  inherit (pkgs) gnome-settings-daemon gnome-tour epiphany geary yelp gnome-text-editor;
  inherit (pkgs.gnomeExtensions) appindicator;
  inherit (config.programs) firefox;
in {
  services.xserver = {
    enable = true;
    displayManager.gdm.enable = true;
    desktopManager.gnome.enable = true;
  };

  environment.gnome.excludePackages = [
    gnome-tour
    epiphany
    geary
    yelp
    gnome-text-editor
  ];

  environment.systemPackages = [
    appindicator
  ];

  services.udev.packages = [
    gnome-settings-daemon
  ];

  # TODO: check if GNOME browser connection is working
  # TODO: update to home-manager config of firefox
  services.gnome.gnome-browser-connector.enable = mkIf firefox.enable true;
}
