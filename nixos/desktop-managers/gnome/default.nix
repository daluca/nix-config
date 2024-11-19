{ config, lib, pkgs, ... }:
let
  inherit (pkgs) gnome-settings-daemon gnome-tour;
  inherit (pkgs.gnomeExtensions) appindicator;
in {
  services.xserver = {
    enable = true;
    displayManager.gdm.enable = true;
    desktopManager.gnome.enable = true;
  };

  environment.gnome.excludePackages = [
    gnome-tour
  ];

  environment.systemPackages = [
    appindicator
  ];

  services.udev.packages = [
    gnome-settings-daemon
  ];

  # TODO: check if GNOME browser connection is working
  # TODO: update to home-manager config of firefox
  services.gnome.gnome-browser-connector.enable = lib.mkIf config.programs.firefox.enable true;
}
