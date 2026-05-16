{ lib, pkgs, ... }:

{
  services.desktopManager.gnome.enable = true;

  services.displayManager.gdm.enable = true;

  environment.gnome.excludePackages = with pkgs; [
    gnome-tour
    epiphany
    geary
    yelp
    gnome-text-editor
  ];

  environment.systemPackages = with pkgs; [
    gnome-sound-recorder
    gnomeExtensions.appindicator
  ];

  services.udev.packages = with pkgs; [
    gnome-settings-daemon
  ];

  services.gnome.gnome-browser-connector.enable = true;

  environment.etc."xdg/monitors.xml".source = ../../../home/desktop-environments/gnome/monitors.xml;

  services.xserver.xkb.options = lib.mkForce "";
}
