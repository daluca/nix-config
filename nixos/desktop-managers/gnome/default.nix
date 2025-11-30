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

  systemd.tmpfiles.rules = [
    "L+ /run/gdm/.config/monitors.xml - - - - ${../../../home/desktop-managers/gnome/monitors.xml}"
  ];

  services.xserver.xkb.options = lib.mkForce "";
}
